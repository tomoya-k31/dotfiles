#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
GITIGNORE_FILE="$PROJECT_ROOT/.gitignore"
JSON_FILE="$PROJECT_ROOT/encrypted-files.json"

SECTION_START="## Encrypted files - managed by encrypted-files.json ##"
SECTION_END="## End encrypted files ##"

if [ ! -f "$JSON_FILE" ]; then
  echo "Error: encrypted-files.json not found" >&2
  exit 1
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

if [ -f "$GITIGNORE_FILE" ]; then
  awk -v start="$SECTION_START" -v end="$SECTION_END" '
        $0 == start { skip = 1; next }
        skip && $0 == end { skip = 0; next }
        !skip
    ' "$GITIGNORE_FILE" >"$tmp"
fi

if [ -s "$tmp" ] && [ "$(tail -c1 "$tmp" | wc -l)" -eq 0 ]; then
  printf '\n' >>"$tmp"
fi

{
  echo "$SECTION_START"
  jq -r '.[].source' "$JSON_FILE"
  echo "$SECTION_END"
} >>"$tmp"

mv "$tmp" "$GITIGNORE_FILE"
trap - EXIT

echo ".gitignore updated with encrypted files from encrypted-files.json"
