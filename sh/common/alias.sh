## alias設定

# ls
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

# du/df
alias du="du -h"
alias df="df -h"
alias duh="du -h ./ --max-depth=1"

# tmux
alias tm='tmux'
alias tma='tmux attach'
alias tml='tmux list-window'

# date
alias today="date '+%Y%m%d'"
alias now="date '+%Y%m%d-%H%M%S'"

# kubernetes
# https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/
alias k=kubectl
