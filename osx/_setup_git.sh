#!/bin/bash

if [[ -z `git config --list | grep user.email` ]]; then
    git config --global user.email "aric.parkinson@gmail.com"
fi

if [[ -z `git config --list | grep user.name` ]]; then
    git config --global user.name "Aric Parkinson"
fi

if [[ -z `git config --list | grep init.defaultBranch` ]]; then
    git config --global init.defaultBranch "main"
fi

if [[ ! -f /usr/local/etc/bash_completion ]]; then
    brew install git bash-completion
fi
