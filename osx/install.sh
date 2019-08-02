#!/bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

cp .bash_profile ~/.bash_profile
./_setup_firefox.sh
./_setup_ssh.sh
./_setup_git.sh
./_setup_vim.sh
./_setup_keybindings.sh
./_setup_python.sh

pushd ../helpers/
./_install_helpers.sh
popd
