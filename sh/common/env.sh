
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# Java
export JAVA_OPTS=-Dfile.encoding=UTF-8

# SDKMAN
export SDKMAN_DIR="${HOME}/.sdkman" && source "${HOME}/.sdkman/bin/sdkman-init.sh"

# DB Unit test
export DB_GIT_REPO_DIR=/Users/usr0200379/Works/Workspace/GmoMedia/mikasa_docker_for_unittest

## Perl
PATH="${HOME}/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"${HOME}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"; export PERL_MM_OPT;

# Python
## Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
## Poetry
export PATH="$HOME/.poetry/bin:$PATH"

## for aws-sam-local
USER_BASE_PATH=$(python -m site --user-base)
export PATH=$PATH:$USER_BASE_PATH
