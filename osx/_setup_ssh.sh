SSH_FILE=${HOME}/.ssh/id_rsa
SSH_CONFIG_FILE=${HOME}/.ssh/config

if [[ ! -f ${SSH_FILE} ]]; then
    echo "Creating ssh key. Please wait for further instructions..."
    ssh-keygen -t rsa -b 4096 -f ${SSH_FILE}

    eval "$(ssh-agent -s)"
    cp ssh-config ${SSH_CONFIG_FILE}
    ssh-add --apple-use-keychain ${SSH_FILE}

    pbcopy < "${SSH_FILE}.pub"
    echo "Your public key has been copied to the clipboard."
    echo "Please add it to Github!"
    read -p "Don't worry, I'll wait..." UNUSED
fi
