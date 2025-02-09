#!/usr/bin/env bash

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the tmux config if it doesn't exist
ZED_DIR="$XDG_CONFIG_HOME/zed"
if [ ! -d "${ZED_DIR}" ]; then
    mkdir -p "${ZED_DIR}"
fi

# Create a link to ~/.config/zed/settings.json
if [ -L "${ZED_DIR}/settings.json" ] || [ -e "${ZED_DIR}/settings.json" ]; then
    mv "${ZED_DIR}/settings.json" "${ZED_DIR}/settings.json.backup"
fi
ln -s "${SCRIPT_DIR}/settings.json" "${ZED_DIR}/settings.json"
