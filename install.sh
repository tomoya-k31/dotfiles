#!/usr/bin/env bash

# XDG
mkdir -p $HOME/.config
mkdir -p $HOME/.cache
mkdir -p $HOME/.data
mkdir -p $HOME/.state

# Store the current directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

DOT_FILES=(.vimrc .bashrc .bash_profile .gvimrc .snippets .zshenv .zprofile .zshrc)

for dotfile in ${DOT_FILES[@]}
do
    if [ -L "${HOME}/${dotfile}" ] || [ -e "${HOME}/${dotfile}" ]; then
        mv "${HOME}/${dotfile}" "${HOME}/${dotfile}.backup"
    fi
    ln -nfs "${SCRIPT_DIR}/${dotfile}" "${HOME}/${dotfile}"
done
