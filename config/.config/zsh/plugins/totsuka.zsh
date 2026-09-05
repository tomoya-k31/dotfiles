## totsuka

# totsuka が dispatch したエージェント pane では、コマンド履歴を一切残さない。
#
# herdr の agent.start は pane の対話シェルへ起動コマンドを打ち込む（protocol 17。
# workspace の env がエージェントに届くのもこの構造のため）。結果として
# `claude --model … --settings … --resume …` の一行が人間の入力と同じ扱いで
# 履歴に入り、share_history で全ターミナルの ↑ を埋める。打ち込むのは herdr な
# ので、hist_ignore_space（行頭スペース）による除外は使えない。
#
# 判定は TOTSUKA_JOB_ID — totsuka が workspace の env 経由でエージェント pane に
# 注入する（herdr.zsh と同じ判定）。伴走シェル pane は pane.split 由来で env を
# 継承しないので、人間が打つ側の履歴は従来どおり残る。
[[ -n $TOTSUKA_JOB_ID ]] || return 0

# zsh 本体の履歴ファイル。HISTFILE を消すだけでなく SAVEHIST=0 と
# share_history / inc_append_history の解除まで行う（どれか 1 つでも残ると
# 書き出し経路が生きる）。
unset HISTFILE
SAVEHIST=0
unsetopt share_history inc_append_history

# hishtory（Ctrl+R の実体）は HISTFILE と無関係に、zshaddhistory / precmd フックで
# 自前の DB へ書く。上の 3 行では止まらないのでフックごと外す。
# このファイルが sheldon の custom plugins（defer 読み込み）ではなく .zshrc から
# 直に source されているのは、hishtory 本体が sheldon の inline プラグインとして
# 読まれる＝フック登録がそれより後になる必要があるため。
autoload -U add-zsh-hook
if (( $+functions[_hishtory_add] )); then
  add-zsh-hook -d zshaddhistory _hishtory_add
  add-zsh-hook -d precmd _hishtory_precmd
fi
