#!/usr/bin/env bash

# ↓OS関係なくBashでのみ適応される設定をずらずら書く
#======================================================

#======================================================

# 共通の設定ファイル読み込み
[[ -e $HOME/.dotfiles/sh/common/ ]] && [[ ! -z "`ls -f $HOME/.dotfiles/sh/common/`" ]] && for f in $HOME/.dotfiles/sh/common/*; do source $f; done
[[ -e $HOME/.dotfiles/sh/bash/ ]] && [[ ! -z "`ls -f $HOME/.dotfiles/sh/bash/`" ]] && for f in $HOME/.dotfiles/sh/bash/*; do source $f; done

# OS別の設定ファイル読み込み
if [ "$(uname)" == 'Darwin' ]; then
    [ -f $HOME/.dotfiles/sh/common.mac ] && source $HOME/.dotfiles/sh/common.mac
    [ -f $HOME/.dotfiles/sh/bash.mac ] && source $HOME/.dotfiles/sh/bash.mac
elif [ "$(uname)" == 'Linux' ]; then
    [ -f $HOME/.dotfiles/sh/common.linux ] && source $HOME/.dotfiles/sh/common.linux
    [ -f $HOME/.dotfiles/sh/bash.linux ] && source $HOME/.dotfiles/sh/bash.linux
else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
