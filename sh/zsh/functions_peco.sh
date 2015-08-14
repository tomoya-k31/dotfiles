

# コマンド履歴のpeco検索
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    # zle clear-screen
}

# ディレクトリ検索
# http://qiita.com/ymorired/items/4b0d8e95786efc1378b4
function peco-find-directory() {
    local current_buffer=$BUFFER
    # .git系など不可視フォルダは除外
    local selected_dir="$(find . -maxdepth 3 -type d ! -path "*/.*"| peco)"
    if [ -d "$selected_dir" ]; then
        BUFFER="${current_buffer} ${selected_dir}"
        CURSOR=$#BUFFER
    fi
    zle clear-screen
}

# tmux セッション検索
function peco-tmux-attach() {
    local res=$(tmux list-sessions | peco | awk -F':' '{print $1}')
    if [ -n "$res" ]; then
        tmux attach -t ${res}
    fi
}



