#!/usr/bin/env bash
set -u

command -v shellcheck >/dev/null 2>&1 || exit 0
command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)
file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

is_shell_file() {
  local f=$1
  case "$f" in
  *.sh | *.bash | *.bats) return 0 ;;
  *.zsh | *.zshrc | *.zshenv | *.zprofile | *.zlogin | *.zlogout) return 1 ;;
  esac
  head -1 "$f" 2>/dev/null | grep -qE '^#![[:space:]]*([^[:space:]]+/)?(env[[:space:]]+)?(bash|sh|dash|ksh|mksh)([[:space:]]|$)'
}

is_shell_file "$file_path" || exit 0

output=$(shellcheck -s bash --color=never "$file_path" 2>&1)
[ -z "$output" ] && exit 0

jq -n --arg ctx "$output" --arg path "$file_path" '{
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: ("shellcheck issues in " + $path + ":\n" + $ctx)
  }
}'

exit 0
