#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DIFF_DIR="$PROJECT_ROOT/.diff"

# Load UI helpers for colored output
source "$SCRIPT_DIR/ui-helpers.sh"

BACKUP_DIR=""
cleanup() {
  [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ] && rm -rf "$BACKUP_DIR"
}
trap cleanup EXIT INT TERM

# Snapshot ours (current source) and ancestor (decrypt of pre-pull encrypted) so
# check_conflicts can run a 3-way merge after decrypt-files.sh overwrites source.
snapshot_prepull_state() {
  BACKUP_DIR=$(mktemp -d)
  while IFS='|' read -r source_path encrypted_path; do
    source_file="$PROJECT_ROOT/$source_path"
    encrypted_file="$PROJECT_ROOT/$encrypted_path"

    if [ -f "$source_file" ]; then
      ours_path="$BACKUP_DIR/ours/$source_path"
      mkdir -p "$(dirname "$ours_path")"
      cp "$source_file" "$ours_path"
    fi

    if [ -f "$encrypted_file" ]; then
      ancestor_path="$BACKUP_DIR/ancestor/$source_path"
      mkdir -p "$(dirname "$ancestor_path")"
      sops -d --input-type binary --output-type binary "$encrypted_file" \
        >"$ancestor_path" 2>/dev/null || rm -f "$ancestor_path"
    fi
  done < <(jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json")
}

# 3-way merge using snapshots from snapshot_prepull_state:
#   ours     = $BACKUP_DIR/ours/<path>      (pre-pull source)
#   ancestor = $BACKUP_DIR/ancestor/<path>  (decrypt of pre-pull encrypted)
#   theirs   = $PROJECT_ROOT/<path>         (post-pull source written by decrypt-files.sh)
check_conflicts() {
  print_step "Conflict Check" "3-way merge against pre-pull snapshot"

  mkdir -p "$DIFF_DIR"
  local conflicts_found=false

  while IFS='|' read -r source_path encrypted_path; do
    source_file="$PROJECT_ROOT/$source_path"
    ours_file="$BACKUP_DIR/ours/$source_path"
    ancestor_file="$BACKUP_DIR/ancestor/$source_path"

    if [ ! -f "$source_file" ]; then
      continue
    fi

    print_file_processed "$source_path"

    local ours_changed=false theirs_changed=false
    if [ -f "$ours_file" ]; then
      if [ -f "$ancestor_file" ]; then
        cmp -s "$ours_file" "$ancestor_file" || ours_changed=true
      else
        ours_changed=true
      fi
    fi
    if [ -f "$ancestor_file" ]; then
      cmp -s "$source_file" "$ancestor_file" || theirs_changed=true
    else
      theirs_changed=true
    fi

    if [ "$ours_changed" = true ] && [ "$theirs_changed" = true ]; then
      if [ -f "$ours_file" ] && cmp -s "$ours_file" "$source_file"; then
        print_no_conflicts "$source_path"
        continue
      fi

      local safe_name diff_file ours_snapshot
      safe_name=$(echo "$source_path" | tr '/' '_')
      diff_file="$DIFF_DIR/$safe_name.diff"
      ours_snapshot="$DIFF_DIR/$safe_name.ours"

      print_conflict "$source_path"
      diff -u --label "ours/$source_path" --label "theirs/$source_path" \
        "$ours_file" "$source_file" >"$diff_file" || true
      cat "$diff_file"
      cp "$ours_file" "$ours_snapshot"
      print_info "Diff: $diff_file"
      print_info "Local copy preserved at: $ours_snapshot"
      conflicts_found=true
    elif [ "$ours_changed" = true ]; then
      # decrypt-files.sh overwrote local edits when remote was unchanged; restore.
      print_info "Restoring local edits: $source_path"
      cp "$ours_file" "$source_file"
    else
      print_no_conflicts "$source_path"
    fi
  done < <(jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json")

  [ "$conflicts_found" = false ]
}

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
  print_error "encrypted-files.json not found"
  exit 1
fi

print_header "Sync with 3-way Merge Logic"

print_phase "1" "Remote Update Detection"
print_git_fetch
git fetch origin

current_branch=$(git branch --show-current)

has_remote_updates=false
has_local_changes=false

# Count commits on origin that we don't have. Treats local-ahead-only as "no remote updates".
remote_only_commits=$(git rev-list --count "HEAD..origin/$current_branch")
if [ "$remote_only_commits" -gt 0 ]; then
  has_remote_updates=true
  print_info "Remote updates detected ($remote_only_commits commit(s) ahead)"
else
  print_success "No remote updates"
fi

# Detect any local changes including untracked (gitignored source files are excluded).
if [ -n "$(git status --porcelain)" ]; then
  has_local_changes=true
  print_info "Local changes detected"
else
  print_success "No local changes"
fi

print_phase "2" "Remote Update Processing"
if [ "$has_remote_updates" = true ]; then

  print_step "2.0" "Snapshotting pre-pull state"
  snapshot_prepull_state

  if [ "$has_local_changes" = true ]; then
    print_git_stash
    git stash push -u -m "Sync: stashed local changes $(date)"
  fi

  print_git_pull
  if ! git pull --ff-only origin "$current_branch"; then
    print_error "Non-fast-forward pull. Local commits diverge from origin/$current_branch."
    print_warning "Resolve manually: git rebase origin/$current_branch (or git merge), then re-run sync."
    if [ "$has_local_changes" = true ]; then
      print_warning "Local changes are stashed. Run 'git stash pop' after resolving."
    fi
    exit 1
  fi

  print_step "2.1" "Decrypting updated files"
  # Use existing decrypt script to update source files
  "$SCRIPT_DIR/decrypt-files.sh"

  # Check for conflicts
  if ! check_conflicts; then
    print_error "Conflicts detected. Please resolve manually."
    if [ "$has_local_changes" = true ]; then
      print_warning "Note: Local changes are stashed. Use 'git stash pop' after resolving conflicts."
    fi
    exit 1
  fi

  # Restore stashed changes if any
  if [ "$has_local_changes" = true ]; then
    print_git_unstash
    if git stash pop; then
      print_success "Local changes restored successfully"
    else
      print_warning "Failed to restore local changes. Check git stash list."
    fi
  fi
else
  print_info "No remote updates, skipping pull"
fi

print_phase "3" "Local Change Processing"
print_progress "Encrypting source files..."

"$SCRIPT_DIR/encrypt-files.sh"

print_step "3.1" "Staging changed encrypted files"
any_changed=false
while IFS='|' read -r source_path encrypted_path; do
  source_file="$PROJECT_ROOT/$source_path"
  encrypted_file="$PROJECT_ROOT/$encrypted_path"
  [ -f "$encrypted_file" ] || continue

  # Use git as source of truth instead of parsing encrypt-files.sh stdout.
  [ -n "$(git status --porcelain -- "$encrypted_file")" ] || continue

  print_file_updated "$encrypted_path"

  # Show source-level diff (HEAD encrypted decrypted vs current source).
  if [ -f "$source_file" ]; then
    head_encrypted=$(mktemp)
    head_decrypted=$(mktemp)
    if git show "HEAD:$encrypted_path" >"$head_encrypted" 2>/dev/null &&
      sops -d --input-type binary --output-type binary "$head_encrypted" >"$head_decrypted" 2>/dev/null; then
      diff -u --label "HEAD/$source_path" --label "current/$source_path" \
        "$head_decrypted" "$source_file" || true
    else
      print_info "  (new file: no HEAD version to diff against)"
    fi
    rm -f "$head_encrypted" "$head_decrypted"
  fi

  git add "$encrypted_file"
  any_changed=true
done < <(jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json")

if [ "$any_changed" = false ]; then
  print_info "No local updates detected"
fi

print_completion "Sync"

# Show any diff files that were created
if [ -d "$DIFF_DIR" ] && [ "$(ls -A "$DIFF_DIR")" ]; then
  print_separator
  print_warning "Conflict diff files created:"
  ls -la "$DIFF_DIR"
  print_separator
  print_info "Please review and manually resolve conflicts in these files."
fi
