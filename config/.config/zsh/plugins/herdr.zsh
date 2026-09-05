## herdr

# herdr のサイドバーに、その pane が居るリポジトリ名を出す。
#
# herdr は pane の cwd を知っているが、それを描画する組み込みトークンが無い
# （built-in は state_icon / state_text / workspace / branch / git_status /
# tab / pane / agent / terminal_title{,_stripped} だけ）。値を出す唯一の手段が
# metadata の報告なので、シェル側から報告する。受け側は
# ~/.config/herdr/config.toml の [ui.sidebar.agents.rows_by_agent] の $repo。
#
# totsuka が dispatch した pane では **何もしない**。トークン名はコンテナごとに
# グローバルで、`--source` は名前空間ではないため（実測: source A が入れた repo を
# source B が上書き・削除できる）。しかも totsuka の worktree では
# `${root:t}` が worktree 名（github-42 等）であって設定上のリポジトリ名では
# ないので、走らせると totsuka の報告を壊す。
# 判定は TOTSUKA_JOB_ID — totsuka が workspace の env 経由でエージェント pane に
# 注入する。伴走シェルには届かない（それは意図された分離で、あちらは別 pane なので
# エージェントのトークンを触らない）。
[[ -n $HERDR_ENV && -n $HERDR_PANE_ID && -z $TOTSUKA_JOB_ID ]] || return 0

autoload -U add-zsh-hook

_herdr_report_repo() {
  local root
  root=$(command git rev-parse --show-toplevel 2>/dev/null) || root=''
  # herdr を叩くのはリポジトリが変わったときだけ。chpwd は cd のたびに
  # 走るので、同じリポジトリ内の移動を git 1 回で済ませるのが効く。
  #
  # 「まだ一度も報告していない」と「リポジトリの外に居る」はどちらも空文字に
  # なるので、${+set} で区別する。同一視すると、pane に前のシェルが残した
  # repo トークンがあるまま非リポジトリで起動したときに clear が走らない。
  # RHS の引用符は GLOB_SUBST 対策（既定の zsh では変数展開したパターン文字は
  # 効かないが、有効にしている環境ではパスの [ ] * が効いてしまう）。
  if [[ ${_herdr_reported_repo_root+set} == set && $root == "$_herdr_reported_repo_root" ]]; then
    return
  fi
  typeset -g _herdr_reported_repo_root=$root
  if [[ -n $root ]]; then
    command herdr pane report-metadata "$HERDR_PANE_ID" \
      --source shell --token repo="${root:t}" &>/dev/null
  else
    # リポジトリの外へ出たら消す。残すと前の repo 名が嘘になる。
    command herdr pane report-metadata "$HERDR_PANE_ID" \
      --source shell --clear-token repo &>/dev/null
  fi
}

add-zsh-hook chpwd _herdr_report_repo
_herdr_report_repo   # 開いた pane にも最初の 1 回
