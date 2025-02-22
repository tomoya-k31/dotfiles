## alias設定

# ls
alias ls="ls --color"
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
alias kubectl=kubecolor
alias k=kubectl
# krew
alias kx='kubectl ctx'
alias kn='kubectl ns'
alias stern='kubectl stern'
alias rolesum='kubectl rolesum'
alias rakkess='kubectl access-matrix'

# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_completion/
source <(kubectl completion zsh)
kubectl completion zsh > "${fpath[1]}/_kubectl"

# Kubecolor https://kubecolor.github.io/setup/shells/zsh/
compdef kubecolor=kubectl

# Sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
