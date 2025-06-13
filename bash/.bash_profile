# ~/.bash_profile

# Source the .bashrc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. "/Users/tomoya-k31/.local/share/cargo/env"

# Hishtory Config:
export PATH="$PATH:/Users/tomoya-k31/.hishtory"
source /Users/tomoya-k31/.hishtory/config.sh
