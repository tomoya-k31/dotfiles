
# ruby - bash
eval "$(rbenv init -)"

# Powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $PYTHON_HOME_DIR/lib/python/site-packages/powerline/bindings/bash/powerline.sh
