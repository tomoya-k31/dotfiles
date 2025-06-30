# ~/.bash_profile

# Source the .bashrc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. ~/.local/share/cargo/env

# Hishtory Config:
export PATH="$PATH:/Users/$(whoami)/.hishtory"
source "/Users/$(whoami)/.hishtory/config.sh"
