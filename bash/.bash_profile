# ~/.bash_profile

# Source the .bashrc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
. ~/.local/share/cargo/env

# Docker Desktop CLI
# （Docker Desktop が末尾に追記してくるが、$(whoami) のサブシェルとガード無しを避けて手動で整理）
[ -d "$HOME/.docker/bin" ] && export PATH="$PATH:$HOME/.docker/bin"
