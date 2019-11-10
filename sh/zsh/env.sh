
# ruby - zsh
eval "$(rbenv init - zsh)"

# direnv
eval "$(direnv hook zsh)"

# perl
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init - zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

