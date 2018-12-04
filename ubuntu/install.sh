HAS_VIM=$(which vim)
HAS_CLIPBOARD=${HAS_VIM} && $(vim --version | grep "+clipboard")

if [[ ${HAS_CLIPBOARD} != "" ]]; then
    sudo apt-get install vim-gtk -y
fi

cp .vimrc ~/.vimrc

