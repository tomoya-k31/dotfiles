
# vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

# Mac標準のsedは使いにくいのでGNU版を使用 'brew install gnu-sed'
alias sed='gsed'

# Mac標準のawkは使いにくいのでGNU版を使用 'brew install gawk'
alias awk='gawk'

# Mac標準のfind/xargsは使いにくいのでGNU版を使用 'brew install findutils'
alias find='gfind'
alias xargs='gxargs'

# Mac標準のdateは使いにくいのでGNU版を使用 'brew install coreutils'
alias date='gdate'
alias readlink='greadlink'

