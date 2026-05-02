#!/usr/bin/env bash
set -u

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "usage: $0 <pane-target>" >&2
  exit 1
fi

i=0
while true; do
  for n in $(seq 0 29); do
    b=$(printf '%*s' "$n" '' | tr ' ' '█')
    e=$(printf '%*s' "$((29-n))" '' | tr ' ' '░')
    printf '\r\033[35m▶\033[0m keepalive [%s%s] %2ds/30  sent: %d ' "$b" "$e" "$n" "$i"
    sleep 1
  done
  tmux send-keys -t "$TARGET" Enter
  i=$((i+1))
done
