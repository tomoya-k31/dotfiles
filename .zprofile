# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export PAGER='less'
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

# Language
export LANG='ja_JP.UTF-8'
export LESSCHARSET='utf-8'
export TERM_LANG='UTF-8'
export LANGUAGE='ja_JP.UTF-8'
export LC_ALL='ja_JP.UTF-8'

# XDG Base Directory仕様のユーザ設定ファイルディレクトリ
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.data"
export XDG_STATE_HOME="$HOME/.state"

# asdf
export ASDF_DIR="$HOME/.asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DATA_DIR=$ASDF_DIR
. "$ASDF_DIR/plugins/java/set-java-home.zsh"

# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# krew (https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
