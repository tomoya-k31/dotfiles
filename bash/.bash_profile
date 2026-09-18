# ~/.bash_profile

# Source the .bashrc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. ~/.local/share/cargo/env

# Hishtory Config:
export PATH="$PATH:/Users/$(whoami)/.hishtory"
source "/Users/$(whoami)/.hishtory/config.sh"

# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/$(whoami)/.docker/bin"
# End of Docker Desktop section.
