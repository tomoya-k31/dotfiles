## Functions

# fzf (Ctrl+T: ファイル検索)
export FZF_CTRL_T_COMMAND="fd --type f --max-depth 8"
export FZF_CTRL_T_OPTS="
    --select-1 --exit-0
    --tmux 80%
    --bind 'ctrl-l:execute(tmux splitw -h -- nvim {})'
    --bind '>:reload($FZF_ALT_C_COMMAND -H -E .git )'
    --bind '<:reload($FZF_ALT_C_COMMAND)'
    --preview 'bat -r :100 --color=always --style=header,grid {}'"

# fzf (Ctrl+F,Ctrl+F: ディレクトリ/ファイル検索 - dotfile含む)
export FZF_ALT_C_COMMAND=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --hidden --max-depth 8 \
    --strip-cwd-prefix \
    --exclude '.git' \
    --exclude 'node_modules' ) \
  || $find_ignore -print 2> /dev/null
EOF
)

function fzf-cd-widget() {
    local current_input="${LBUFFER}"
    local selected=$(eval "$FZF_ALT_C_COMMAND" | \
        fzf --reverse \
            --select-1 --exit-0 \
            --tmux 80% \
            --bind "tab:replace-query" \
            --preview '$ZDOTDIR/bin/fzf-preview {}'
    )
    # --bind "tab:replace-query,tab:reload(fd --type d --max-depth 1 --strip-cwd-prefix {})" \

    selected=$(echo "$selected" | sed -E 's/([() ])/\\\1/g')
    if [ -n "$selected" ]; then
        LBUFFER="$current_input$selected"
        zle redisplay
    fi
}
bindkey '^f^f' fzf-cd-widget
