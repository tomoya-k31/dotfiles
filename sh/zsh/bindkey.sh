
# 履歴からコマンド選択
zle -N peco-select-history
bindkey '^r' peco-select-history

# 隠しファイルの表示切り替え
zle -N toggle-show-all-files
bindkey '^t^t' toggle-show-all-files

# ディレクトリ検索
zle -N peco-find-directory
bindkey '^f^f' peco-find-directory