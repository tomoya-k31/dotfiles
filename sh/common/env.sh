
# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# Java
export JAVA_OPTS=-Dfile.encoding=UTF-8

# SBT options
export SBT_OPTS="-Xmx2G -XX:MaxPermSize=2G -Xss2M"

# SDKMAN
export SDKMAN_DIR="${HOME}/.sdkman" && source "${HOME}/.sdkman/bin/sdkman-init.sh"

# Gradle デーモンの常駐
export GRADLE_OPTS="-Dorg.gradle.daemon=true -Dorg.gradle.jvmargs='-Xmx1024m -XX:CICompilerCount=2 -XX:ParallelGCThreads=2'"

# DB Unit test
export DB_GIT_REPO_DIR=/Users/usr0200379/Works/Workspace/GmoMedia/mikasa_docker_for_unittest

## Perl
PATH="${HOME}/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"${HOME}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"; export PERL_MM_OPT;
