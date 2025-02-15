# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zhistory
# メモリに保存される履歴の件数
export HISTSIZE=3000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=300000
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

# https://github.com/tmux/tmux/issues/223
if [ ${TMUX} ]; then
    unset zle_bracketed_paste
fi

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

# uv
eval "$(uv generate-shell-completion zsh)"

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

# fzf
source <(fzf --zsh)
# fzf (Ctrl+T: ファイル検索)
export FZF_CTRL_T_COMMAND="fd --type f --max-depth 8"
export FZF_CTRL_T_OPTS="
    --select-1 --exit-0
    --tmux 80%
    --bind 'ctrl-l:execute(tmux splitw -h -- nvim {})'
    --bind '>:reload($FZF_ALT_C_COMMAND -H -E .git )'
    --bind '<:reload($FZF_ALT_C_COMMAND)'
    --preview 'bat -r :100 --color=always --style=header,grid {}'"

# fzf (Ctrl+F,Ctrl+F: ディレクトリ検索)
export FZF_ALT_C_COMMAND=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --type d --max-depth 8 \
    --strip-cwd-prefix \
    --exclude '{node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)

function fzf-cd-widget() {
    local current_input="${LBUFFER}"
    local selected=$(eval "$FZF_ALT_C_COMMAND" | \
        fzf --reverse \
            --select-1 --exit-0 \
            --tmux 80% \
            --bind "tab:replace-query" \
            --preview 'tree -aC -L 2 {} | head -200'
    )
    # --bind "tab:replace-query,tab:reload(fd --type d --max-depth 1 --strip-cwd-prefix {})" \
    
    selected=$(echo "$selected" | sed -E 's/([() ])/\\\1/g')
    if [ -n "$selected" ]; then
        LBUFFER="$current_input$selected"
        zle redisplay
    fi
}
bindkey '^f^f' fzf-cd-widget


function gitadd() {
    local selected
    selected=$(git status -s | grep -E '^\?|^ ' | fzf --reverse -m --ansi --preview="echo {} | awk '{print \$NF}' | xargs git diff --color" | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        selected=$(tr '\n' ' ' <<< "$selected" | sed 's/^ *//; s/ *$//')
        echo $selected | xargs git add
        echo "Completed: git add $selected"
    fi
}

function gitlog() {
    git log --graph --color --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d' \
    | fzf --ansi --reverse --no-sort \
      --preview='echo {} | grep -o "[a-f0-9]\{7\}" && git show --color $(echo {} | grep -o "[a-f0-9]\{7\}")'
}
