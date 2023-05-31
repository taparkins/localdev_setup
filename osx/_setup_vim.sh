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
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
fi

# Copy over custom vimrc
cp .vimrc ~/.vim_runtime/my_configs.vim
