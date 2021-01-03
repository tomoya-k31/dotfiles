# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zhistory
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
# 補完時にヒストリを自動的に展開
setopt hist_expand
# 履歴をインクリメンタルに追加
setopt inc_append_history
setopt nobeep autocd


## ----- oh my zsh ----- ##
export ZSH=$HOME/.oh-my-zsh
COMPLETION_WAITING_DOTS="true"

plugins=(
    git
    zsh-completions
    zsh-syntax-highlighting
    zsh-autosuggestions
)

autoload -U compinit && compinit
source $ZSH/oh-my-zsh.sh
## ----- oh my zsh ----- ##


# Starship
eval "$(starship init zsh)"

# Customize to your needs...
source $HOME/.dotfiles/.zshrc.custom
