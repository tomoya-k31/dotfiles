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
  export EDITOR='mvim'
  export VISUAL='mvim'
fi

# Language
if [[ -z "$LANG" ]]; then
  export LANG='ja_JP.UTF-8'
fi

# XDG Base Directory仕様のユーザ設定ファイルディレクトリ
export XDG_CONFIG_HOME="$HOME/.config"
