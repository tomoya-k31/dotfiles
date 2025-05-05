## Tools

# Load 1Password plugins
source ~/.config/op/plugins.sh


# 上矢印キーでfzfによる逆順履歴検索を起動
function fzf-history-widget() {
  local selected=$(tac $HISTFILE | sed 's/^: [0-9]*:[0-9]*;//' | fzf --query="$LBUFFER" --prompt="History> ")
  if [[ -n $selected ]]; then
    LBUFFER=$selected
    zle redisplay
  fi
}
zle -N fzf-history-widget
bindkey '^[[A' fzf-history-widget
