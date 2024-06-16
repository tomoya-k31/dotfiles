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
# Emacsキーバインディング
bindkey -e

# https://stackoverflow.com/questions/54061286/setting-zsh-disable-compfix-true-in-zshrc-doesnt-work
export ZSH_DISABLE_COMPFIX=true

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:(cd|less):*' matcher 'm:{a-z}={A-Z}'
zstyle ':completion:*:setopt:*' menu true select
autoload -Uz compinit
compinit

# Starship
eval "$(starship init zsh)"
# starshipでpyenvの環境が重複してしまうのを解消
export PYENV_VIRTUALENV_DISABLE_PROMPT=1 

# Zoxide
eval "$(zoxide init zsh)"

### Added by Zinit's installer
if [[ ! -f $HOME/.data/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.data/zinit" && command chmod g-rwX "$HOME/.data/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.data/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.data/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust
### End of Zinit's installer chunk


# Reload Zsh to install Zinit:
# - exec zsh
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-syntax-highlighting"


# Customize to your needs...
. $HOME/.dotfiles/.zshrc.custom

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('~/.pyenv/versions/miniconda3-latest/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "~/.pyenv/versions/miniconda3-latest/etc/profile.d/conda.sh" ]; then
        . "~/.pyenv/versions/miniconda3-latest/etc/profile.d/conda.sh"
    else
        export PATH="~/.pyenv/versions/miniconda3-latest/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# asdf
. $(brew --prefix asdf)/libexec/asdf.sh
