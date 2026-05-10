#!/bin/bash
# =============================================================================
# resolve-gh-action-sha.sh
#
# 指定した GitHub Action の最新パッチバージョンを取得し、SHA ピン形式で出力する
#
# 依存: gh (GitHub CLI), jq
# 認証: gh auth login 済みであること
#
# 使用方法:
#   ./resolve-gh-action-sha.sh <owner/repo>[@<ref>]
#
# 例:
#   ./resolve-gh-action-sha.sh actions/checkout
#   ./resolve-gh-action-sha.sh actions/setup-node@v4.4.0
#
# 出力形式:
#   owner/repo@<sha> # <version>
# =============================================================================

set -euo pipefail

INPUT="${1:?Usage: $0 <owner/repo>[@<ref>]}"

# 入力を repo と ref に分解（ref は省略可）
if [[ "$INPUT" == *"@"* ]]; then
  REPO="${INPUT%@*}"
  PINNED_REF="${INPUT##*@}"
else
  REPO="$INPUT"
  PINNED_REF=""
fi

# Local action / Docker action はスキップ対象なのでエラーで返す
case "$REPO" in
./* | . | docker://*)
  echo "❌ ローカル/Docker action は SHA ピンの対象外です: ${REPO}" >&2
  exit 2
  ;;
esac

# ==========================================================================
# Step 1: 最新パッチバージョンを特定（PINNED_REF が指定されていればそれを使用）
#
# releases/latest は v1 のようなメジャータグを返す場合があるため、
# リリース一覧から semver（x.y.z）形式のタグを探す
# ==========================================================================

REF=""

if [ -n "$PINNED_REF" ]; then
  REF="$PINNED_REF"
  echo "指定バージョン: ${REF}" >&2
else
  # semver パターン: v1.0.64, 2.3.1 など（ドットが2つ以上ある数値タグ）
  SEMVER_FILTER='[.[] | select(.tag_name | test("^v?[0-9]+\\.[0-9]+\\.[0-9]+")) | .tag_name][0] // empty'

  # A: リリース一覧（日付降順）から semver の最新を取得
  REF=$(gh api "repos/${REPO}/releases?per_page=10" 2>/dev/null | jq -r "$SEMVER_FILTER") || true

  # B: リリースになければタグ一覧から sort -V で最新を取得
  if [ -z "$REF" ]; then
    REF=$(gh api "repos/${REPO}/tags?per_page=30" 2>/dev/null |
      jq -r '.[] | .name' |
      grep -E '^v?[0-9]+\.[0-9]+\.[0-9]+' |
      sort -V |
      tail -1) || true
  fi

  # C: semver タグが一切なければ最新タグをそのまま使用
  if [ -z "$REF" ]; then
    REF=$(gh api "repos/${REPO}/tags?per_page=1" 2>/dev/null | jq -r '.[0].name // empty') || true
  fi

  # D: タグもなければデフォルトブランチ
  if [ -z "$REF" ]; then
    REF=$(gh api "repos/${REPO}" 2>/dev/null | jq -r '.default_branch // empty') || true
  fi

  if [ -z "$REF" ]; then
    echo "❌ ${REPO} の最新バージョンを特定できませんでした" >&2
    exit 1
  fi

  echo "最新バージョン: ${REF}" >&2
fi

# ==========================================================================
# Step 2: SHA を解決
# ==========================================================================

resolve_tag() {
  local response obj_type obj_sha
  response=$(gh api "repos/${REPO}/git/ref/tags/${REF}" 2>/dev/null) || return 1
  obj_type=$(echo "$response" | jq -r '.object.type')
  obj_sha=$(echo "$response" | jq -r '.object.sha')

  case "$obj_type" in
  tag)
    gh api "repos/${REPO}/git/tags/${obj_sha}" | jq -r '.object.sha'
    ;;
  commit)
    echo "$obj_sha"
    ;;
  *)
    return 1
    ;;
  esac
}

resolve_branch() {
  gh api "repos/${REPO}/git/ref/heads/${REF}" 2>/dev/null | jq -r '.object.sha'
}

SHA=$(resolve_tag || resolve_branch) || {
  echo "❌ ${REPO}@${REF} のSHAを解決できませんでした" >&2
  exit 1
}

echo "${REPO}@${SHA} # ${REF}"
