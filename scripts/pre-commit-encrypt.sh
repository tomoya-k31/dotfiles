#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/setup-sops-key.sh"

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
    echo "Error: encrypted-files.json not found" >&2
    exit 1
fi

changed_files=false

# Process each file from encrypted-files.json
jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json" | while IFS='|' read -r source_path encrypted_path; do
    source_file="$PROJECT_ROOT/$source_path"
    encrypted_file="$PROJECT_ROOT/$encrypted_path"
    
    # Check if source file exists and is being committed
    for staged_file in "$@"; do
        if [ "$staged_file" = "$source_path" ]; then
            echo "Checking encrypted file for: $source_path"
            
            # If encrypted file doesn't exist, create it
            if [ ! -f "$encrypted_file" ]; then
                echo "Creating encrypted file: $encrypted_file"
                mkdir -p "$(dirname "$encrypted_file")"
                sops -e "$source_file" > "$encrypted_file"
                git add "$encrypted_file"
                changed_files=true
                continue
            fi
            
            # Decrypt existing encrypted file to temp file for comparison
            temp_decrypted=$(mktemp)
            trap "rm -f $temp_decrypted" EXIT
            
            if sops -d "$encrypted_file" > "$temp_decrypted" 2>/dev/null; then
                # Compare source file with decrypted version
                if ! cmp -s "$source_file" "$temp_decrypted"; then
                    echo "Source file changed, updating encrypted version: $encrypted_file"
                    sops -e "$source_file" > "$encrypted_file"
                    git add "$encrypted_file"
                    changed_files=true
                fi
            else
                echo "Failed to decrypt $encrypted_file, recreating..."
                sops -e "$source_file" > "$encrypted_file"
                git add "$encrypted_file"
                changed_files=true
            fi
            
            rm -f "$temp_decrypted"
            break
        fi
    done
done

if [ "$changed_files" = true ]; then
    echo "Encrypted files updated and staged for commit"
fi

exit 0