
# 履歴からコマンド選択
zle -N peco-select-history
bindkey '^r' peco-select-history

# 隠しファイルの表示切り替え
zle -N toggle-show-all-files
bindkey '^t^t' toggle-show-all-files

# ディレクトリ検索
zle -N peco-find-directory
bindkey '^f^f' peco-find-directory

# スニペット検索
zle -N peco-snippets
bindkey '^x^s' peco-snippets
zle -N peco-snippets-copy
bindkey '^x^x' peco-snippets-copy