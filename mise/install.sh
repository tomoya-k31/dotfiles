#!/usr/bin/env bash

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the mise config if it doesn't exist
MISE_DIR="$XDG_CONFIG_HOME/mise"
if [ ! -d "${MISE_DIR}" ]; then
    mkdir -p "${MISE_DIR}"
fi

# Create a link to ~/.config/mise/config.toml
if [ -L "${MISE_DIR}/config.toml" ] || [ -e "${MISE_DIR}/config.toml" ]; then
    mv "${MISE_DIR}/config.toml" "${MISE_DIR}/config.toml.backup"
fi
ln -s "${SCRIPT_DIR}/config.toml" "${MISE_DIR}/config.toml"
