#!/usr/bin/env bash
# issue（または PR）を GitHub Project に載せ、ステータスを入れ、読み返して確認する。
#
#   add-to-gh-project.sh <owner> <project-number> <issue-url> <status> [status-field]
#
# 読み返しがこのスクリプトの本体。item-add が成功してもステータスは別の書き込みで、
# 「載っただけでステータスが空」「選択肢名が 1 文字違って入らない」が実際に起きる。
# 期待した値が読み返せなければ非 0 で終わる。
set -euo pipefail

if [ $# -lt 4 ] || [ $# -gt 5 ]; then
  echo "usage: $(basename "$0") <owner> <project-number> <issue-url> <status> [status-field]" >&2
  exit 2
fi
owner=$1
number=$2
url=$3
status=$4
field=${5:-Status}

gh project item-add "$number" --owner "$owner" --url "$url" >/dev/null
gh project item-edit "$number" --owner "$owner" --url "$url" --field "$field" --value "$status" >/dev/null

# 書き込み直後は item-list に反映されていないことがあるので、3 秒おきに最大 3 回読み直す。
max_retries=3
for ((retry = 0; ; retry++)); do
  actual=$(gh project item-list "$number" --owner "$owner" --limit 500 --format json \
    --jq ".items[] | select(.content.url == \"${url}\") | .status // \"\"")
  if [ "$actual" = "$status" ] || [ "$retry" -ge "$max_retries" ]; then
    break
  fi
  sleep 3
done

if [ "$actual" != "$status" ]; then
  echo "error: ${url} のステータスが期待と違う: expected=[${status}] actual=[${actual}]" >&2
  exit 1
fi
echo "ok: ${url} -> ${status}"
