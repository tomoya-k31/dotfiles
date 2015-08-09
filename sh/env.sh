
# Java
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export JAVA_OPTS=-Dfile.encoding=UTF-8

# jetty
export JETTY_HOME=/usr/local/jetty9.0


# Python
#export PATH=${PATH}:/usr/local/Cellar/python/2.7.5/bin
export PYENV_ROOT="${HOME}/.pyenv"
[ -d "${PYENV_ROOT}" ] && {
    export PATH=${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}
    eval "$(pyenv init -)"
}

# Config File
export TOMCAT_CNF=/usr/local/apache-tomcat-7.0.35/conf
export NGINX_CNF=/usr/local/etc/nginx/nginx.conf
export REDIS_CNF=/usr/local/etc/redis.conf
export MYSQL_CNF=/usr/local/var/mysql/my.cnf


# Play Framework
export PATH=${PATH}:/usr/local/play

# sbt options
export SBT_OPTS="-Xmx2G -XX:MaxPermSize=2G -Xss2M"

# android
export PATH=${PATH}:$HOME/development/Android-SDK/tools
export PATH=${PATH}:$HOME/development/Android-SDK/platform-tools

# SEADeamon
alias skysea_stop="/Applications/SKYSEAClientView.app/Contents/MacOS/SkyDaemon -stop"
alias skysea_start="/Applications/SKYSEAClientView.app/Contents/MacOS/SkyDaemon -start &"

# Gradle
[[ -s ~/.gvm/bin/gvm-init.sh ]] && source ~/.gvm/bin/gvm-init.sh
# デーモンの常駐
export GRADLE_OPTS="-Dorg.gradle.daemon=true"

# nvm
[[ -s ~/.nvm/nvm.sh ]] && {
  source ~/.nvm/nvm.sh
  export NODE_PATH=${NVM_PATH}_modules
}
