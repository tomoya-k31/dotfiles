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

actual=$(gh project item-list "$number" --owner "$owner" --limit 500 --format json \
  --jq ".items[] | select(.content.url == \"${url}\") | .status // \"\"")

if [ "$actual" != "$status" ]; then
  echo "error: ${url} のステータスが期待と違う: expected=[${status}] actual=[${actual}]" >&2
  exit 1
fi
echo "ok: ${url} -> ${status}"
