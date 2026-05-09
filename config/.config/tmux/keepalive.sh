#!/usr/bin/env bash
set -u

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "usage: $0 <pane-target>" >&2
  exit 1
fi

CACHE_FILE=/tmp/claude/statusline-usage-cache.json
CACHE_MAX_AGE=300

is_claude_code_pane() {
  local pid p child
  local -a frontier=() next=() all=()
  pid=$(tmux display-message -p -t "$1" '#{pane_pid}' 2>/dev/null)
  [ -z "$pid" ] && return 1
  frontier=("$pid")
  all=("$pid")
  while [ "${#frontier[@]}" -gt 0 ]; do
    next=()
    for p in "${frontier[@]}"; do
      while IFS= read -r child; do
        [ -n "$child" ] && { next+=("$child"); all+=("$child"); }
      done < <(pgrep -P "$p" 2>/dev/null)
    done
    frontier=("${next[@]:-}")
    [ -z "${frontier[0]:-}" ] && break
  done
  for p in "${all[@]}"; do
    if ps -o args= -p "$p" 2>/dev/null | grep -qE '(^|/| )claude($| |[^a-zA-Z0-9_-])'; then
      return 0
    fi
  done
  return 1
}

get_current_pct_from_cache() {
  [ -f "$CACHE_FILE" ] || { printf 'stale'; return; }
  local mtime now age
  mtime=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)
  now=$(date +%s)
  age=$(( now - mtime ))
  if [ "$age" -gt "$CACHE_MAX_AGE" ]; then
    printf 'stale'
    return
  fi
  jq -r '.five_hour.utilization // empty' "$CACHE_FILE" 2>/dev/null \
    | awk 'NF{printf "%.0f", $1}'
}

i=0
skipped=0
last_state="init"
while true; do
  for n in $(seq 0 29); do
    b=$(printf '%*s' "$n" '' | tr ' ' '█')
    e=$(printf '%*s' "$((29-n))" '' | tr ' ' '░')
    printf '\r\033[35m▶\033[0m keepalive [%s%s] %2ds/30  sent: %d  skipped: %d  [%s] ' "$b" "$e" "$n" "$i" "$skipped" "$last_state"
    sleep 1
  done
  if is_claude_code_pane "$TARGET"; then
    pct=$(get_current_pct_from_cache)
    if [ "$pct" = stale ] || [ -z "$pct" ]; then
      last_state="claude (cache stale)"
    else
      last_state="claude current=${pct}%"
      if [ "$pct" -ge 90 ] 2>/dev/null; then
        skipped=$((skipped+1))
        continue
      fi
    fi
  else
    last_state="other"
  fi
  tmux send-keys -t "$TARGET" Enter
  i=$((i+1))
done
