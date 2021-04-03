#!/usr/bin/env bash

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the fd config if it doesn't exist
FD_DIR="$XDG_CONFIG_HOME/fd"
if [ ! -d "${FD_DIR}" ]; then
    mkdir -p "${FD_DIR}"
fi

# Create a link to ~/.config/fd/ignore
if [ -L "${FD_DIR}/ignore" ] || [ -e "${FD_DIR}/ignore" ]; then
    mv "${FD_DIR}/ignore" "${FD_DIR}/ignore.backup"
fi
ln -s "${SCRIPT_DIR}/ignore" "${FD_DIR}/ignore"
