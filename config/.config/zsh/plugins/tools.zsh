## Tools

# Load 1Password plugins
source ~/.config/op/plugins.sh

# VSCode
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
