#!/usr/bin/env bash

os_detect() {
    export OS_TYPE
    if [ "$(uname)" == 'Darwin' ]; then
        OS_TYPE='mac'
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        OS_TYPE='linux'
    else
        echo "Your platform ($(uname -a)) is not supported."
        exit 1
    fi
}

# 実行, $OS_TYPEで参照できるようs
os_detect
