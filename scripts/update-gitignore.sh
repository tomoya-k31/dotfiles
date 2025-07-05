#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
GITIGNORE_FILE="$PROJECT_ROOT/.gitignore"

# Section markers
SECTION_START="## Encrypted files - managed by encrypted-files.json ##"
SECTION_END="## End encrypted files ##"

if [ ! -f "$PROJECT_ROOT/encrypted-files.json" ]; then
    echo "Error: encrypted-files.json not found" >&2
    exit 1
fi

# Remove old encrypted files section if exists
sed -i '' "/^$SECTION_START$/,/^$SECTION_END$/d" "$GITIGNORE_FILE"

# Add encrypted files section (only if not already exists)
if ! grep -q "$SECTION_START" "$GITIGNORE_FILE"; then
    # Add newline only if file doesn't end with one
    if [ -s "$GITIGNORE_FILE" ] && [ "$(tail -c1 "$GITIGNORE_FILE" | wc -l)" -eq 0 ]; then
        echo "" >> "$GITIGNORE_FILE"
    fi
    echo "$SECTION_START" >> "$GITIGNORE_FILE"
    jq -r '.[].source' "$PROJECT_ROOT/encrypted-files.json" >> "$GITIGNORE_FILE"
    echo "$SECTION_END" >> "$GITIGNORE_FILE"
fi

echo ".gitignore updated with encrypted files from encrypted-files.json"
