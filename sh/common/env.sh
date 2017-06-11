
# Java
export JAVA_OPTS=-Dfile.encoding=UTF-8

# SBT options
export SBT_OPTS="-Xmx2G -XX:MaxPermSize=2G -Xss2M"

# Gradle デーモンの常駐
export GRADLE_OPTS="-Dorg.gradle.daemon=true -Dorg.gradle.jvmargs='-Xmx1024m -XX:CICompilerCount=2 -XX:ParallelGCThreads=2'"
