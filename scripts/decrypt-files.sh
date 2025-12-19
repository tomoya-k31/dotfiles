#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/setup-sops-key.sh"

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
    echo "Error: encrypted-files.json not found" >&2
    exit 1
fi

echo "Decrypting files..."


# Process each file from encrypted-files.json
jq -r '.[] | "\(.source)|\(.encrypted)"' "$PROJECT_ROOT/encrypted-files.json" | while IFS='|' read -r source_path encrypted_path; do
    source_file="$PROJECT_ROOT/$source_path"
    encrypted_file="$PROJECT_ROOT/$encrypted_path"
    
    if [ ! -f "$encrypted_file" ]; then
        echo "Warning: Encrypted file not found: $encrypted_file"
        continue
    fi
    
    echo "Checking: $source_path"
    
    # Decrypt encrypted file to temp file for comparison
    temp_decrypted=$(mktemp)
    trap "rm -f $temp_decrypted" EXIT
    
    # Determine output type based on file extension
    output_type=""
    case "$source_file" in
        *.json) output_type="--output-type json" ;;
        *.yaml|*.yml) output_type="--output-type yaml" ;;
    esac

    if ! sops -d $output_type "$encrypted_file" > "$temp_decrypted" 2>/dev/null; then
        echo "Error: Failed to decrypt $encrypted_file"
        rm -f "$temp_decrypted"
        continue
    fi
    
    # If source file doesn't exist, create it
    if [ ! -f "$source_file" ]; then
        echo "Creating source file: $source_file"
        mkdir -p "$(dirname "$source_file")"
        cp "$temp_decrypted" "$source_file"
    else
        # Compare source file with decrypted version
        if ! cmp -s "$source_file" "$temp_decrypted"; then
            echo "Encrypted file changed, updating source: $source_file"
            cp "$temp_decrypted" "$source_file"
        fi
    fi
    
    rm -f "$temp_decrypted"
done
