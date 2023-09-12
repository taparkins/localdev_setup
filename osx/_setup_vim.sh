#!/bin/bash

set -e


# Install version with clipboard support
HAS_VIM=$(brew ls --versions vim)
HAS_CLIPBOARD=$([[ ! -z ${HAS_VIM} ]] && echo $(vim --version | grep +clipboard))

if [[ -z ${HAS_CLIPBOARD} ]]; then
    echo "No vim with clipboard -- installing a proper version!"

    if [[ ${HAS_VIM} != "" ]]; then
        brew uninstall vim
    fi

    brew install vim
    echo "Vim reinstalled -- be sure to start a new terminal after to get correct version!"
fi

# Install Vim Awesome + custom configs
if [[ ! -d ~/.vim_runtime ]]; then
    mkdir ~/.vim_runtime
    pushd ~/.vim_runtime

    # we're looking to do a shallow-clone based on a specific commit
    # you cannot directly clone from a specified SHA, so we're working
    # around it based on this suggestion:
    # https://stackoverflow.com/a/43136160
    git init
    git remote add origin https://github.com/taparkins/vimrc.git
    # Oct 11, 2021
    git fetch --depth 1 origin 92c794cc2b5206f199ff6e2e2c4840a3d49c0ea8
    git checkout FETCH_HEAD
    sh ~/.vim_runtime/install_awesome_vimrc.sh

    popd
fi

# Copy over custom vimrc
cp .vimrc ~/.vim_runtime/my_configs.vim
