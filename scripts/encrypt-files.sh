#!/bin/bash

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
    
    echo "Encrypting: $source_file -> $encrypted_file"
    
    mkdir -p "$(dirname "$encrypted_file")"
    
    sops -e "$source_file" > "$encrypted_file"
    
    echo "✓ Encrypted: $encrypted_file"
done

echo "All files encrypted successfully!"