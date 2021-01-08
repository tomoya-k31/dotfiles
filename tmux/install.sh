#!/usr/bin/env bash

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the tmux config if it doesn't exist
TMUX_DIR="$XDG_CONFIG_HOME/tmux"
if [ ! -d "${TMUX_DIR}" ]; then
    mkdir -p "${TMUX_DIR}"
fi

# Create a link to ~/.config/tmux/tmux.conf
if [ -L "${TMUX_DIR}/tmux.conf" ] || [ -e "${TMUX_DIR}/tmux.conf" ]; then
    mv "${TMUX_DIR}/tmux.conf" "${TMUX_DIR}/tmux.conf.backup"
fi
ln -s "${SCRIPT_DIR}/tmux.conf" "${TMUX_DIR}/tmux.conf"
