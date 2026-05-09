#!/usr/bin/env bash
set -u

command -v shfmt >/dev/null 2>&1 || exit 0
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

shfmt -w -i 2 "$file_path" 2>/dev/null
exit 0
