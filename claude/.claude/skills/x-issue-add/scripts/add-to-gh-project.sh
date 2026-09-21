#!/usr/bin/env bash
# issue（または PR）を GitHub Project に載せ、ステータスを入れ、読み返して確認する。
#
#   add-to-gh-project.sh <owner> <project-number> <issue-url> <status> [status-field]
#
# 読み返しがこのスクリプトの本体。item-add が成功してもステータスは別の書き込みで、
# 「載っただけでステータスが空」「選択肢名が 1 文字違って入らない」が実際に起きる。
# 期待した値が読み返せなければ非 0 で終わる。
#
# gh project item-edit は名前を受け取らず ID だけを取る（--owner / --field / --value は無い）。
# そのため field・選択肢・project・item の ID を先に引く。選択肢の解決は item-add より前に
# やり、Status 名が違うときはボードに何も載せずに終わる。
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

field_json=$(gh project field-list "$number" --owner "$owner" --limit 100 --format json |
  jq -c --arg f "$field" '.fields[] | select(.name == $f)')
if [ -z "$field_json" ]; then
  echo "error: project ${owner}/${number} に field [${field}] が無い" >&2
  exit 1
fi
field_type=$(jq -r '.type' <<<"$field_json")
if [ "$field_type" != "ProjectV2SingleSelectField" ]; then
  echo "error: field [${field}] が単一選択ではない: type=${field_type}" >&2
  exit 1
fi
field_id=$(jq -r '.id' <<<"$field_json")
option_id=$(jq -r --arg s "$status" '.options[] | select(.name == $s) | .id' <<<"$field_json")
if [ -z "$option_id" ]; then
  echo "error: field [${field}] に選択肢 [${status}] が無い。選択肢:" >&2
  jq -r '.options[] | "  [" + .name + "]"' <<<"$field_json" >&2
  exit 1
fi

project_id=$(gh project view "$number" --owner "$owner" --format json --jq '.id')
# 既にボードにある item でも既存の item を返すので、再実行しても重複しない。
item_id=$(gh project item-add "$number" --owner "$owner" --url "$url" --format json --jq '.id')
gh project item-edit --id "$item_id" --project-id "$project_id" \
  --field-id "$field_id" --single-select-option-id "$option_id" >/dev/null

# 書き込み直後は item-list に反映されていないことがあるので、3 秒おきに最大 3 回読み直す。
max_retries=3
for ((retry = 0; ; retry++)); do
  actual=$(gh project item-list "$number" --owner "$owner" --limit 500 --format json |
    jq -r --arg u "$url" '.items[] | select(.content.url == $u) | .status // ""')
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
