
# ruby - zsh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# direnv
eval "$(direnv hook zsh)"

# SDKMAN
export SDKMAN_DIR="${HOME}/.sdkman" && source "${HOME}/.sdkman/bin/sdkman-init.sh"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

## Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

## Poetry
export PATH="$HOME/.local/bin:$PATH"
