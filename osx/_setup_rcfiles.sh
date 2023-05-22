CURRENT_ZSHRC_VERSION=1

if [[ -z "$LOCALDEV_ZSHRC_VERSION" ]]; then
    cat .zshrc >> ~/.zshrc
fi

HAS_COREUTILS=$(brew ls --versions coreutils)
if [[ -z ${HAS_COREUTILS} ]]; then
    brew install coreutils
fi

if [[ ! -d "~/.dircolors" ]]; then
    git clone https://github.com/gibbling666/dircolors.git ~/.dircolors
fi

if [[ "$LOCALDEV_ZSHRC_VERSION" != "$CURRENT_ZSHRC_VERSION" ]]; then
    cp .dircolors ~/.dircolors
    cp .external_rc ~/.external_rc
    source ~/.external_rc
fi
