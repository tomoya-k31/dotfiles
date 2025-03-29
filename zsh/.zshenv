# ~/.zshenv

### locale ###
unsetopt GLOBAL_RCS
# export LANG='ja_JP.UTF-8'
export LANG="en_US.UTF-8"
export LESSCHARSET='utf-8'
export TERM_LANG='UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# XDG Base Directory仕様のユーザ設定ファイルディレクトリ
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

### zsh ###
# Set ZDOTDIR to the location of the dotfiles repository
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

### Rust ###
export RUST_BACKTRACE=1
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
source "$XDG_DATA_HOME/cargo/env"

### Go ###
export GOPATH="$XDG_DATA_HOME/go"

### Deno ###
export DENO_INSTALL="$XDG_DATA_HOME/deno"
export DENO_INSTALL_ROOT="$DENO_INSTALL"

### Java ###
export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"

### k8s ###
export KREW_ROOT="$XDG_DATA_HOME/krew"
export PATH="${KREW_ROOT}/bin:$PATH"

### Python ###
export RYE_HOME="$XDG_DATA_HOME/rye"
source "$RYE_HOME/env"

### Ansible
export ANSIBLE_HOME="$XDG_DATA_HOME/ansible"
