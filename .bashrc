#!/usr/bin/env bash

source $HOME/.dotfiles/config.sh

# ↓OS関係なくBashでのみ適応される設定をずらずら書く
#======================================================

#======================================================

# 共通の設定ファイル読み込み
[[ -e $HOME/.dotfiles/sh/common/ ]] && [[ ! -z "`ls -f $HOME/.dotfiles/sh/common/`" ]] && for f in $HOME/.dotfiles/sh/common/*; do source $f; done
[[ -e $HOME/.dotfiles/sh/bash/ ]] && [[ ! -z "`ls -f $HOME/.dotfiles/sh/bash/`" ]] && for f in $HOME/.dotfiles/sh/bash/*; do source $f; done

# OS別の設定ファイル読み込み
case "${OS_TYPE}" in
    mac)
      [ -f $HOME/.dotfiles/sh/common.mac ] && source $HOME/.dotfile/sh/common.mac
      [ -f $HOME/.dotfiles/sh/bash.mac ] && source $HOME/.dotfile/sh/bash.mac
      ;;
    linux)
      [ -f $HOME/.dotfiles/sh/common.linux ] && source $HOME/.dotfiles/sh/common.linux
      [ -f $HOME/.dotfiles/sh/bash.linux ] && source $HOME/.dotfiles/sh/bash.linux
      ;;
    *)
      exit 1 ;;
esac
