#!/bin/sh

DOT_FILES=( .zshrc .zshenv .vimrc .tmux.conf .bashrc .gvimrc )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/.dotfiles/$file $HOME/$file
done
