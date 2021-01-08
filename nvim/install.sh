#!/usr/bin/env bash

# Check if neovim, ripgrep, cargo, python3, and pip3 are installed
if ! [ -x "$(command -v nvim)" ]; then
    echo "nvim not found on path, exiting" >&2
    exit 1
fi

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Create the neovim config if it doesn't exist
NVIM_DIR="$XDG_CONFIG_HOME/nvim"
if [ ! -d "${NVIM_DIR}" ]; then
    mkdir -p "${NVIM_DIR}"
fi

# Create a link to init.vim
if [ -L "${NVIM_DIR}/init.vim" ] || [ -e "${NVIM_DIR}/init.vim" ]; then
    mv "${NVIM_DIR}/init.vim" "${NVIM_DIR}/init.vim.backup"
fi
ln -s "${SCRIPT_DIR}/init.vim" "${NVIM_DIR}/init.vim"

# Create a link to the config directory
if [ -L "${NVIM_DIR}/config" ] || [ -d "${NVIM_DIR}/config" ]; then
    rm -rf "${NVIM_DIR}/config.backup"
    mv "${NVIM_DIR}/config" "${NVIM_DIR}/config.backup"
fi
ln -s "${SCRIPT_DIR}/config" "${NVIM_DIR}/config"

# Create a link to settings.json
if [ -L "${NVIM_DIR}/settings.json" ] || [ -e "${NVIM_DIR}/settings.json" ]; then
    mv "${NVIM_DIR}/settings.json" "${NVIM_DIR}/settings.json.backup"
fi
ln -s "${SCRIPT_DIR}/settings.json" "${NVIM_DIR}/settings.json"

# Install vim plugin manager
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $XDG_CACHE_HOME/dein
