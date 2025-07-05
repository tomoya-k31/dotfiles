#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DIFF_DIR="$PROJECT_ROOT/.diff"

# Load UI helpers for colored output
source "$SCRIPT_DIR/ui-helpers.sh"

# Function to check for conflicts after remote updates
check_conflicts() {
    print_step "Conflict Check" "Analyzing differences between source and encrypted files"
    
    mkdir -p "$DIFF_DIR"
    conflicts_found=false
    
    jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json" | while IFS='|' read -r source_path encrypted_path; do
        source_file="$PROJECT_ROOT/$source_path"
        encrypted_file="$PROJECT_ROOT/$encrypted_path"
        
        if [ ! -f "$encrypted_file" ] || [ ! -f "$source_file" ]; then
            continue
        fi
        
        print_file_processed "$source_path"
        
        # Decrypt to temporary file
        temp_decrypted=$(mktemp)
        trap "rm -f $temp_decrypted" EXIT
        
        if ! sops -d "$encrypted_file" > "$temp_decrypted" 2>/dev/null; then
            print_error "Failed to decrypt $encrypted_file"
            continue
        fi
        
        # Compare decrypted content with source
        if ! cmp -s "$source_file" "$temp_decrypted"; then
            print_conflict "$source_file"
            diff_file="$DIFF_DIR/$(echo "$source_path" | tr '/' '_').diff"
            
            # Create diff file
            print_info "Creating diff: $diff_file"
            diff -u "$source_file" "$temp_decrypted" > "$diff_file" || true
            print_info "Diff saved to: $diff_file"
            conflicts_found=true
        else
            print_no_conflicts "$source_file"
        fi
        
        rm -f "$temp_decrypted"
    done
    
    if [ "$conflicts_found" = true ]; then
        print_warning "Conflicts found. Please review diff files in .diff/ directory"
        return 1
    fi
    print_success "No conflicts detected"
    return 0
}

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
    print_error "encrypted-files.json not found"
    exit 1
fi

print_header "Smart Sync with 3-way Merge Logic"

print_phase "1" "Remote Update Detection"
print_git_fetch
git fetch origin

current_branch=$(git branch --show-current)
local_commit=$(git rev-parse HEAD)
remote_commit=$(git rev-parse origin/$current_branch)

has_remote_updates=false
has_local_changes=false

if [ "$local_commit" != "$remote_commit" ]; then
    has_remote_updates=true
    print_info "Remote updates detected"
else
    print_success "No remote updates"
fi

# Check for local changes in tracked files
if ! git diff --quiet HEAD; then
    has_local_changes=true
    print_info "Local changes detected"
else
    print_success "No local changes in tracked files"
fi

print_phase "2" "Remote Update Processing"
if [ "$has_remote_updates" = true ]; then
    
    if [ "$has_local_changes" = true ]; then
        print_git_stash
        git stash push -m "Sync: stashed local changes $(date)"
    fi
    
    print_git_pull
    git pull origin $current_branch
    
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
print_progress "Checking for local changes to encrypt..."

# Use existing encrypt script and capture any changes
encrypt_output=$("$SCRIPT_DIR/encrypt-files.sh" 2>&1)
echo "$encrypt_output"

if echo "$encrypt_output" | grep -q "Updated\|Created\|Recreated"; then
    print_step "3.1" "Staging encrypted files"
    
    # Add all encrypted files to git
    jq -r '.[].encrypted' "$PROJECT_ROOT/encrypted-files.json" | while read -r encrypted_path; do
        encrypted_file="$PROJECT_ROOT/$encrypted_path"
        if [ -f "$encrypted_file" ]; then
            git add "$encrypted_file"
            print_file_updated "$encrypted_path"
        fi
    done
    
    print_phase "4" "Git Operations"
    if ! git diff --cached --quiet; then
        print_git_commit
        git commit -m "Update encrypted configuration files

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        
        print_git_push
        git push origin $current_branch
        print_success "Local updates pushed successfully"
    else
        print_info "No changes to commit"
    fi
else
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