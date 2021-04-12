
# ruby - zsh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# direnv
eval "$(direnv hook zsh)"

# perl
export PATH="$HOME/.plenv/bin:$PATH"
export PERL_CPANM_OPT="--local-lib=$HOME/.perl5"
export PERL5LIB=/usr/local/lib/perl5:$PERL5LIB
eval "$(plenv init - zsh)"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
