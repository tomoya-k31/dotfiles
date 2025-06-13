# ~/.bashrc

# XDG Base Directory specifications
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Configure history
export HISTFILE="$XDG_DATA_HOME"/bash/history
mkdir -p "$(dirname "$HISTFILE")"
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000

# User specific aliases and functions
alias ll='ls -la'
alias gs='git status'
alias la='ls -A'
alias l='ls -CF'
alias vi='vim'

source "/Users/$(whoami)/.local/share/cargo/env'

# Hishtory Config:
export PATH="$PATH:/Users/$(whoami)/.hishtory"
source /Users/$(whoami)/.hishtory/config.sh
