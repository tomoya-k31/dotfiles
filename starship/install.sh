#!/usr/bin/env bash

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the config if it doesn't exist
CONFIG_DIR="$XDG_CONFIG_HOME"
if [ ! -d "${CONFIG_DIR}" ]; then
    mkdir -p "${CONFIG_DIR}"
fi

# Create a link to ~/.config/starship.toml
if [ -L "${CONFIG_DIR}/starship.toml" ] || [ -e "${CONFIG_DIR}/starship.toml" ]; then
    mv "${CONFIG_DIR}/starship.toml" "${CONFIG_DIR}/starship.toml.backup"
fi
ln -s "${SCRIPT_DIR}/starship.toml" "${CONFIG_DIR}/starship.toml"
