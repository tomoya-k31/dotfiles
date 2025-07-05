#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/setup-sops-key.sh"

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
    echo "Error: encrypted-files.json not found" >&2
    exit 1
fi

echo "Encrypting files..."

jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json" | while IFS='|' read -r source_path encrypted_path; do
    source_file="$PROJECT_ROOT/$source_path"
    encrypted_file="$PROJECT_ROOT/$encrypted_path"
    
    if [ ! -f "$source_file" ]; then
        echo "Warning: Source file not found: $source_file"
        continue
    fi
    
    echo "Checking: $source_path"
    
    # If encrypted file doesn't exist, create it
    if [ ! -f "$encrypted_file" ]; then
        echo "Creating encrypted file: $encrypted_file"
        mkdir -p "$(dirname "$encrypted_file")"
        sops -e "$source_file" > "$encrypted_file"
        echo "✓ Created: $encrypted_file"
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
            echo "✓ Updated: $encrypted_file"
        fi
    else
        echo "Failed to decrypt $encrypted_file, recreating..."
        sops -e "$source_file" > "$encrypted_file"
        echo "✓ Recreated: $encrypted_file"
    fi
    
    rm -f "$temp_decrypted"
done
