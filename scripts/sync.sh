#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DIFF_DIR="$PROJECT_ROOT/.diff"

# Function to check for conflicts after remote updates
check_conflicts() {
    echo "Checking for conflicts between source and encrypted files..."
    
    mkdir -p "$DIFF_DIR"
    conflicts_found=false
    
    jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json" | while IFS='|' read -r source_path encrypted_path; do
        source_file="$PROJECT_ROOT/$source_path"
        encrypted_file="$PROJECT_ROOT/$encrypted_path"
        
        if [ ! -f "$encrypted_file" ] || [ ! -f "$source_file" ]; then
            continue
        fi
        
        # Decrypt to temporary file
        temp_decrypted=$(mktemp)
        trap "rm -f $temp_decrypted" EXIT
        
        if ! sops -d "$encrypted_file" > "$temp_decrypted" 2>/dev/null; then
            echo "Error: Failed to decrypt $encrypted_file"
            continue
        fi
        
        # Compare decrypted content with source
        if ! cmp -s "$source_file" "$temp_decrypted"; then
            echo "⚠ Conflict detected: $source_file"
            diff_file="$DIFF_DIR/$(echo "$source_path" | tr '/' '_').diff"
            
            # Create diff file
            echo "Creating diff: $diff_file"
            diff -u "$source_file" "$temp_decrypted" > "$diff_file" || true
            echo "Diff saved to: $diff_file"
            conflicts_found=true
        fi
        
        rm -f "$temp_decrypted"
    done
    
    if [ "$conflicts_found" = true ]; then
        echo "⚠ Conflicts found. Please review diff files in .diff/ directory"
        return 1
    fi
    return 0
}

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
    echo "Error: encrypted-files.json not found" >&2
    exit 1
fi

echo "Starting sync..."

# Step 1: Check for remote updates
echo "Step 1: Checking for remote updates..."
git fetch origin

current_branch=$(git branch --show-current)
local_commit=$(git rev-parse HEAD)
remote_commit=$(git rev-parse origin/$current_branch)

has_remote_updates=false
has_local_changes=false

if [ "$local_commit" != "$remote_commit" ]; then
    has_remote_updates=true
    echo "Remote updates detected"
else
    echo "No remote updates"
fi

# Check for local changes in tracked files
if ! git diff --quiet HEAD; then
    has_local_changes=true
    echo "Local changes detected"
else
    echo "No local changes in tracked files"
fi

# Step 2: Handle remote updates
if [ "$has_remote_updates" = true ]; then
    echo "Step 2: Handling remote updates..."
    
    if [ "$has_local_changes" = true ]; then
        echo "Local changes detected, stashing them..."
        git stash push -m "Sync: stashed local changes $(date)"
    fi
    
    echo "Pulling remote updates..."
    git pull origin $current_branch
    
    echo "Step 3: Processing updated encrypted files..."
    # Use existing decrypt script to update source files
    "$SCRIPT_DIR/decrypt-files.sh"
    
    # Check for conflicts
    if ! check_conflicts; then
        echo "Conflicts detected. Please resolve manually."
        if [ "$has_local_changes" = true ]; then
            echo "Note: Local changes are stashed. Use 'git stash pop' after resolving conflicts."
        fi
        exit 1
    fi
    
    # Restore stashed changes if any
    if [ "$has_local_changes" = true ]; then
        echo "Restoring stashed local changes..."
        if git stash pop; then
            echo "Local changes restored successfully"
        else
            echo "Warning: Failed to restore local changes. Check git stash list."
        fi
    fi
else
    echo "Step 2: No remote updates, skipping pull"
fi

# Step 3: Handle local changes using existing encrypt script
echo "Step 3: Checking for local changes to encrypt..."

# Use existing encrypt script and capture any changes
encrypt_output=$("$SCRIPT_DIR/encrypt-files.sh" 2>&1)
echo "$encrypt_output"

if echo "$encrypt_output" | grep -q "Updated\|Created\|Recreated"; then
    echo "Encrypted files were updated, staging changes..."
    
    # Add all encrypted files to git
    jq -r '.[].encrypted' "$PROJECT_ROOT/encrypted-files.json" | while read -r encrypted_path; do
        encrypted_file="$PROJECT_ROOT/$encrypted_path"
        if [ -f "$encrypted_file" ]; then
            git add "$encrypted_file"
        fi
    done
    
    # Step 4: Commit and push if there are local updates
    if ! git diff --cached --quiet; then
        echo "Step 4: Committing and pushing local updates..."
        git commit -m "Update encrypted configuration files

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
        
        git push origin $current_branch
        echo "✓ Local updates pushed successfully"
    else
        echo "No changes to commit"
    fi
else
    echo "No local updates detected"
fi

echo "Sync completed!"

# Show any diff files that were created
if [ -d "$DIFF_DIR" ] && [ "$(ls -A "$DIFF_DIR")" ]; then
    echo ""
    echo "⚠ Conflict diff files created:"
    ls -la "$DIFF_DIR"
    echo ""
    echo "Please review and manually resolve conflicts in these files."
fi