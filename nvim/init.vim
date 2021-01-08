let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME

source $CONFIG/nvim/config/plugins.vim
source $CONFIG/nvim/config/editor.vim
source $CONFIG/nvim/config/theme.vim
source $CONFIG/nvim/config/keybindings.vim


