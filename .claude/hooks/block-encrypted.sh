#!/usr/bin/env bash
set -u

command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

[ -z "$file_path" ] && exit 0

case "$file_path" in
*.encrypted)
  reason="Direct edits to encrypted files are blocked: $file_path. Edit the plaintext source and run \`make encrypt\` to regenerate. See CLAUDE.md '機密ファイルの取り扱い'."
  jq -n --arg r "$reason" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
      }
    }'
  exit 0
  ;;
esac

exit 0
