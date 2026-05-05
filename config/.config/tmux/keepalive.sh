#!/usr/bin/env bash
set -u

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "usage: $0 <pane-target>" >&2
  exit 1
fi

is_claude_code_pane() {
  printf '%s' "$1" | grep -qE 'current[^0-9]+[0-9]+%'
}

get_current_pct() {
  printf '%s\n' "$1" | grep -oE 'current[^0-9]+[0-9]+%' | tail -1 | grep -oE '[0-9]+'
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
  content=$(tmux capture-pane -p -t "$TARGET" 2>/dev/null)
  if is_claude_code_pane "$content"; then
    pct=$(get_current_pct "$content")
    pct=${pct:-0}
    last_state="claude current=${pct}%"
    if [ "$pct" -ge 90 ] 2>/dev/null; then
      skipped=$((skipped+1))
      continue
    fi
  else
    last_state="other"
  fi
  tmux send-keys -t "$TARGET" Enter
  i=$((i+1))
done
