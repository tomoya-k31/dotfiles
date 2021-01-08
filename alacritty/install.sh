#!/usr/bin/env bash

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the alacritty config if it doesn't exist
ALACRITTY_DIR="$XDG_CONFIG_HOME/alacritty"
if [ ! -d "${ALACRITTY_DIR}" ]; then
    mkdir -p "${ALACRITTY_DIR}"
fi

# Create a link to ~/.config/alacritty/alacritty.yml
if [ -L "${ALACRITTY_DIR}/alacritty.yml" ] || [ -e "${ALACRITTY_DIR}/alacritty.yml" ]; then
    mv "${ALACRITTY_DIR}/alacritty.yml" "${ALACRITTY_DIR}/alacritty.yml.backup"
fi
ln -s "${SCRIPT_DIR}/alacritty.yml" "${ALACRITTY_DIR}/alacritty.yml"
