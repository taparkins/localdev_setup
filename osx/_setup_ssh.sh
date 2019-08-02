if [[ ! -f ${HOME}/.ssh/id_rsa ]]; then
    echo "Creating ssh key. Please wait for further instructions..."
    ssh-keygen -t rsa -b 4096
    ssh-add -K ${HOME}/.ssh/id_rsa
    pbcopy < ${HOME}/.ssh/id_rsa.pub
    echo "Your public key has been copied to the clipboard."
    echo "Please add it to Github!"
    read -p "Don't worry, I'll wait..." UNUSED
fi
