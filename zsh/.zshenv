# ~/.zshenv

# Language
export LANG='ja_JP.UTF-8'
export LESSCHARSET='utf-8'
export TERM_LANG='UTF-8'
export LANGUAGE='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

# XDG Base Directory仕様のユーザ設定ファイルディレクトリ
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# Set ZDOTDIR to the location of the dotfiles repository
export ZDOTDIR=$HOME/.config/zsh
. "$HOME/.cargo/env"
