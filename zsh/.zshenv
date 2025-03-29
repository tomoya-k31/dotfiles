# ~/.zshenv

### locale ###
unsetopt GLOBAL_RCS
# export LANG='ja_JP.UTF-8'
export LANG="en_US.UTF-8"
export LESSCHARSET='utf-8'
export TERM_LANG='UTF-8'
export LANGUAGE='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

# XDG Base Directory仕様のユーザ設定ファイルディレクトリ
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

. "$HOME/.cargo/env"

### zsh ###
# Set ZDOTDIR to the location of the dotfiles repository
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

### Rust ###
export RUST_BACKTRACE=1
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

### Deno ###
export DENO_INSTALL="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL"
