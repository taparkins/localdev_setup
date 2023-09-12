#!/bin/bash

set -e


OLD_SSH_FILE=${HOME}/.ssh/id_rsa
NEW_SSH_FILE=${HOME}/.ssh/id_localdev
SSH_CONFIG_FILE=${HOME}/.ssh/config

if [[ -f ${OLD_SSH_FILE} ]]; then
    echo "Legacy SSH key already exists. Skipping..."
    exit 0
elif [[ -f ${NEW_SSH_FILE} ]]; then
    echo "SSH key already exists. Skipping..."
    exit 0
fi

echo "Creating ssh key. Please wait for further instructions..."
ssh-keygen -t ed25519 -b 4096 -f ${NEW_SSH_FILE}

eval "$(ssh-agent -s)"
cp ssh-config ${SSH_CONFIG_FILE}
ssh-add --apple-use-keychain ${NEW_SSH_FILE}

pbcopy < "${NEW_SSH_FILE}.pub"
echo "Your public key has been copied to the clipboard."
echo "Please add it to Github!"
read -p "Don't worry, I'll wait..." UNUSED
