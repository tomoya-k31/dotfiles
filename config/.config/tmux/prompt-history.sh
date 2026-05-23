#!/usr/bin/env bash
# prompt-history — Claude Code interaction log explorer
#
# Search past user_prompts captured by the interaction-logger plugin. Reads
# every ~/.claude/logs/interactions-*.jsonl into an in-tmpdir DuckDB, then
# opens a 3-stage fzf picker (cwd → session → user_prompt). The chosen
# prompt's full text is copied to the macOS clipboard via pbcopy.
#
# Companion (future): prompt-snippet.sh — searches curated/saved prompt snippets.
#
# Designed to be launched either from a normal terminal:
#   $ ~/.config/tmux/prompt-history.sh
# or from a tmux popup (see tmux.conf bind-key H).
#
# Requirements: duckdb, fzf, jq, pbcopy (all available on the user's mac).
#
# Internal subcommands (used by fzf --preview):
#   __preview_cwd <cwd>
#   __preview_session <session_id>
#   __preview_prompt <ts>          (reads PHIST_SEL_SESSION from env)
set -euo pipefail

LOG_DIR="${HOME}/.claude/logs"
PHIST_SCRIPT="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
export PHIST_SCRIPT

# Double single-quotes for safe SQL string interpolation.
sql_esc() { printf "%s" "${1//\'/\'\'}"; }

# Run a query against the cached DB. Stdin = SQL, stdout = JSON array.
duck_json() {
  duckdb "${PHIST_DB:?PHIST_DB not exported}" -json 2>/dev/null
}

# Markdown highlighter for fzf preview panes. bat 前提（依存チェック済み）。
# tmux popup / fzf と同じ Catppuccin Mocha テーマで色を統一する。
md_highlight() {
  bat --language=md --theme='Catppuccin Mocha' \
    --color=always --style=plain --paging=never
}

# fzf 共通オプション (Catppuccin Mocha)。各 stage は --border-label / --header /
# --preview / --with-nth だけ差し替えて呼ぶ。色はすべて 16進指定。
fzf_common_opts=(
  --layout=reverse
  --border=rounded
  --border-label-pos=3
  --preview-window=right:55%:wrap:border-rounded
  --preview-label=' preview '
  --preview-label-pos=3
  --prompt='❯ '
  --pointer='▸'
  --marker='✓'
  --info=inline-right
  --separator='─'
  --scrollbar='│'
  --color=fg:#cdd6f4
  --color=bg:-1
  --color=hl:#74c7ec
  --color=fg+:#cdd6f4
  --color=bg+:#313244
  --color=hl+:#89dceb
  --color=border:#cba6f7
  --color=label:#b4befe
  --color=prompt:#f5c2e7
  --color=pointer:#b4befe
  --color=marker:#f5c2e7
  --color=header:#74c7ec
  --color=info:#a6adc8
  --color=spinner:#74c7ec
  --color=separator:#45475a
  --color=preview-bg:-1
  --color=preview-border:#585b70
  --color=preview-label:#b4befe
)

# ────────────────────────────────────────────────────────────
# fzf preview callbacks
# ────────────────────────────────────────────────────────────
case "${1:-}" in
__preview_cwd)
  cwd_esc=$(sql_esc "${2:-}")
  sql=$(
    cat <<SQL
SELECT
    cwd,
    COUNT(DISTINCT session_id) AS sessions,
    COUNT(*) FILTER (WHERE event = 'user_prompt') AS prompts,
    MIN(ts) AS first_ts,
    MAX(ts) AS last_ts,
    (SELECT string_agg(
        '• ' || regexp_replace(prompt, chr(10) || '|' || chr(13), ' ⏎ ', 'g'),
        chr(10) || chr(10))
     FROM (SELECT prompt FROM events
           WHERE cwd = '${cwd_esc}' AND event = 'user_prompt'
           ORDER BY ts DESC LIMIT 5)) AS recent
FROM events
WHERE cwd = '${cwd_esc}'
GROUP BY cwd;
SQL
  )
  printf '%s\n' "$sql" | duck_json | jq -r '
.[] | "**cwd:**      \(.cwd)
**sessions:** \(.sessions)
**prompts:**  \(.prompts)
**first:**    \(.first_ts)
**last:**     \(.last_ts)

### latest 5 prompts

\(.recent // "_(none)_")"' | md_highlight
  exit 0
  ;;
__preview_session)
  session_esc=$(sql_esc "${2:-}")
  sql=$(
    cat <<SQL
SELECT
    session_id,
    MIN(ts) AS started,
    MAX(ts) AS ended,
    COUNT(*) AS events,
    COUNT(*) FILTER (WHERE event = 'user_prompt') AS prompts,
    (SELECT prompt FROM events
     WHERE session_id = '${session_esc}' AND event = 'user_prompt'
     ORDER BY ts LIMIT 1) AS first_prompt
FROM events
WHERE session_id = '${session_esc}'
GROUP BY session_id;
SQL
  )
  printf '%s\n' "$sql" | duck_json | jq -r '
.[] | "**session:**  \(.session_id)
**started:**  \(.started)
**ended:**    \(.ended)
**events:**   \(.events)
**prompts:**  \(.prompts)

### first user_prompt

\(.first_prompt // "_(none)_")"' | md_highlight
  exit 0
  ;;
__preview_prompt)
  session_esc=$(sql_esc "${PHIST_SEL_SESSION:?PHIST_SEL_SESSION not set}")
  ts_esc=$(sql_esc "${2:-}")
  sql=$(
    cat <<SQL
SELECT prompt FROM events
WHERE session_id = '${session_esc}'
  AND ts = '${ts_esc}'
  AND event = 'user_prompt'
LIMIT 1;
SQL
  )
  printf '%s\n' "$sql" | duck_json | jq -r '.[0].prompt // "_(not found)_"' | md_highlight
  exit 0
  ;;
esac

# ────────────────────────────────────────────────────────────
# Main entry
# ────────────────────────────────────────────────────────────
for bin in duckdb fzf jq pbcopy bat; do
  command -v "$bin" >/dev/null || {
    printf 'prompt-history:required command not found: %s\n' "$bin" >&2
    exit 1
  }
done

shopt -s nullglob
log_files=("${LOG_DIR}"/interactions-*.jsonl)
shopt -u nullglob
if ((${#log_files[@]} == 0)); then
  printf 'prompt-history:no log files in %s/interactions-*.jsonl\n' "$LOG_DIR" >&2
  exit 1
fi

TMPDIR_PHIST=$(mktemp -d -t phist.XXXXXX)
cleanup() {
  rm -rf "$TMPDIR_PHIST"
  # duckdb only writes ~/.duckdb_history in interactive mode (we never are),
  # but scrub an empty leftover just in case.
  if [[ -f "$HOME/.duckdb_history" && ! -s "$HOME/.duckdb_history" ]]; then
    rm -f "$HOME/.duckdb_history"
  fi
}
trap cleanup EXIT
PHIST_DB="${TMPDIR_PHIST}/events.duckdb"
export PHIST_DB

# Build the cache once; preview subshells reuse the same DB file.
build_sql=$(
  cat <<SQL
SET temp_directory = '${TMPDIR_PHIST}/dtmp';
CREATE TABLE events AS
SELECT * FROM read_json_auto(
    '${LOG_DIR}/interactions-*.jsonl',
    format = 'newline_delimited',
    union_by_name = true,
    ignore_errors = true
);
SQL
)
printf '%s\n' "$build_sql" | duckdb "$PHIST_DB" >/dev/null

TAB=$'\t'

# ────── Stage 1: cwd ──────
stage1_sql=$(
  cat <<'SQL'
SELECT
    cwd,
    COUNT(*) FILTER (WHERE event = 'user_prompt') AS prompts,
    COUNT(DISTINCT session_id) AS sessions,
    MAX(ts) AS last_active
FROM events
WHERE cwd IS NOT NULL
GROUP BY cwd
ORDER BY last_active ASC;
SQL
)
# 表示行は「整形済み1列 ＋ TAB ＋ 完全cwd」に。fzf は1列目のみ表示し、
# 選択時は2列目（隠し列）から完全 cwd を取り出す。
# 短縮ルール: $HOME を "~" に置換 → セグメント数 ≤ 2 はそのまま、それ以外は
# 末尾2セグメントだけ残して中間を "..." に圧縮（例: ~/a/b/c/d → ~/.../c/d）。
stage1_lines=$(printf '%s\n' "$stage1_sql" | duck_json | jq -r --arg home "$HOME" '
  def abbrev_cwd:
    (if ($home | length) > 0 and (. == $home or startswith($home + "/"))
       then "~" + .[$home | length :]
       else . end) as $h
    | ($h | split("/")) as $parts
    | (if ($parts[0] // "") == "~" then "~" else "" end) as $prefix
    | ($parts[1:]) as $segs
    | if ($segs | length) <= 2 then $h
      else $prefix + "/.../" + ($segs[-2:] | join("/"))
      end;
  .[] | [(.cwd | abbrev_cwd), (.prompts|tostring), (.sessions|tostring), .last_active, .cwd] | @tsv
' | awk -F'\t' '
  BEGIN {
    hdr[1] = "cwd"; hdr[2] = "prompts"; hdr[3] = "sessions"; hdr[4] = "last_active"
    for (i = 1; i <= 4; i++) w[i] = length(hdr[i])
  }
  # pass 1: 全行を保持しつつ列幅を測る（ヘッダ文字列も対象）
  { rows[NR] = $0
    for (i = 1; i <= 4; i++) {
      L = length($i); if (L > w[i]) w[i] = L
    }
  }
  END {
    # ヘッダ行（fzf 側で --header-lines=1 として扱う）
    printf "%-*s  %*s  %*s  %-*s\n", \
      w[1], hdr[1], w[2], hdr[2], w[3], hdr[3], w[4], hdr[4]
    # データ行: 1〜4列目を整形、5列目（完全cwd）は TAB 区切りで隠し保持
    for (n = 1; n <= NR; n++) {
      split(rows[n], f, "\t")
      printf "%-*s  %*s  %*s  %-*s\t%s\n", \
        w[1], f[1], w[2], f[2], w[3], f[3], w[4], f[4], f[5]
    }
  }')
sel=$(printf '%s\n' "$stage1_lines" | fzf \
  "${fzf_common_opts[@]}" \
  --border-label=' ✨ Prompt History · 1/3 cwd ' \
  --delimiter="$TAB" \
  --with-nth=1 \
  --header-lines=1 \
  --header='Esc to abort' \
  --preview="\"$PHIST_SCRIPT\" __preview_cwd {2}" || true)
[[ -z "$sel" ]] && exit 0
CWD=$(printf '%s' "$sel" | awk -F"$TAB" '{print $2}')
cwd_esc=$(sql_esc "$CWD")

# ────── Stage 2: session ──────
stage2_sql=$(
  cat <<SQL
SELECT
    session_id,
    MIN(ts) AS started,
    COUNT(*) FILTER (WHERE event = 'user_prompt') AS prompts,
    COUNT(*) AS events
FROM events
WHERE cwd = '${cwd_esc}'
GROUP BY session_id
ORDER BY started ASC;
SQL
)
stage2_lines=$(printf '%s\n' "$stage2_sql" | duck_json | jq -r '.[] | [.session_id, .started, (.prompts|tostring), (.events|tostring)] | @tsv')
sel=$(printf '%s\n' "$stage2_lines" | fzf \
  "${fzf_common_opts[@]}" \
  --border-label=" ✨ Prompt History · 2/3 session in $CWD " \
  --delimiter="$TAB" \
  --with-nth=2,3,4,1 \
  --header='started │ prompts │ events │ session_id' \
  --preview="\"$PHIST_SCRIPT\" __preview_session {1}" || true)
[[ -z "$sel" ]] && exit 0
SESSION=$(printf '%s' "$sel" | awk -F"$TAB" '{print $1}')
session_esc=$(sql_esc "$SESSION")
export PHIST_SEL_SESSION="$SESSION"

# ────── Stage 3: user_prompt ──────
stage3_sql=$(
  cat <<SQL
SELECT
    ts,
    LEFT(regexp_replace(prompt, chr(10) || '|' || chr(13), ' ⏎ ', 'g'), 240) AS preview
FROM events
WHERE session_id = '${session_esc}'
  AND event = 'user_prompt'
ORDER BY ts;
SQL
)
stage3_lines=$(printf '%s\n' "$stage3_sql" | duck_json | jq -r '.[] | [.ts, .preview] | @tsv')
sel=$(printf '%s\n' "$stage3_lines" | fzf \
  "${fzf_common_opts[@]}" \
  --border-label=" ✨ Prompt History · 3/3 prompts " \
  --delimiter="$TAB" \
  --with-nth=1,2 \
  --header='Enter = copy to clipboard' \
  --preview="\"$PHIST_SCRIPT\" __preview_prompt {1}" || true)
[[ -z "$sel" ]] && exit 0
TS=$(printf '%s' "$sel" | awk -F"$TAB" '{print $1}')
ts_esc=$(sql_esc "$TS")

fetch_sql=$(
  cat <<SQL
SELECT prompt FROM events
WHERE session_id = '${session_esc}'
  AND ts = '${ts_esc}'
  AND event = 'user_prompt'
LIMIT 1;
SQL
)
FULL=$(printf '%s\n' "$fetch_sql" | duck_json | jq -r '.[0].prompt // ""')

if [[ -z "$FULL" ]]; then
  printf 'prompt-history:failed to fetch full prompt for ts=%s\n' "$TS" >&2
  exit 1
fi

printf '%s' "$FULL" | pbcopy
bytes=$(printf '%s' "$FULL" | wc -c | tr -d ' ')
printf '\n✓ copied to clipboard (%s bytes)  ts=%s\n' "$bytes" "$TS"

# Brief pause so the user sees the confirmation when launched in a tmux popup
# (popup auto-closes when the script exits).
read -r -t 1.2 -n 1 _ || true
