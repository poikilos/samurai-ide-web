#!/bin/bash

if [ ! -f "`command -v apt-get`" ]; then
    echo "Error: This script is only compatible with Debian-based distros. Try installing nodejs and yarn (or npm) manually."
    exit 1
fi

# if [ "$EUID" -eq 0 ]; then
#     echo "Error: You must run this script as root."
#     exit 1
# fi
NEED_ANY_PKG=false
NEED_NODE=false
printf "* install curl..."

if [ ! -f "`command -v curl`" ]; then
    echo "yes"
    NEED_ANY_PKG=true
else
    echo "no (found `command -v curl`)"
fi

printf "* install nodejs..."
if [ ! -f "`command -v node`" ]; then
    if [ ! -f "`command -v nodejs`" ]; then
        echo "yes"
        NEED_ANY_PKG=true
        NEED_NODE=true
    else
        echo "no (found `command -v nodejs`)"
    fi
else
    echo "no (found `command -v node`)"
fi

if [ "@$NEED_ANY_PKG" = "@true" ]; then
    sudo apt update
fi
if [ ! -f "`command -v curl`" ]; then
    sudo apt install -y curl
fi
if [ "@$NEED_NODE" = "@true" ]; then
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt install -y nodejs
    echo "  * installed nodejs `node -v`"
    echo "  * installed npm `npm -v`"
else
    echo "  * found nodejs `node -v`"
    echo "  * found npm `npm -v`"
fi

NEED_YARN=false
printf "* install yarn..."
if [ ! -f "`command -v yarn`" ]; then
    if [ ! -f "`command -v yarnpkg`" ]; then
        echo "yes"
        NEED_YARN=true
    else
        echo "no (found `command -v yarnpkg`)"
    fi
else
    echo "no (found `command -v yarn`)"
fi

if [ "@$NEED_YARN" = "@true" ]; then
    printf "* corepack enable (installs yarn on Node.js>=16.10 as per <https://yarnpkg.com/getting-started/install>)..."
    sudo corepack enable
    code=$?
    if [ $code -eq 0 ]; then
        echo "OK"
    else
        echo "FAILED"
        exit $code
    fi
fi

printf "  * testing for yarn..."
yarn --version >& /dev/null
code=$?
if [ $code -eq 0 ]; then
    echo "OK"
else
    echo "FAILED"
    exit $code
fi
