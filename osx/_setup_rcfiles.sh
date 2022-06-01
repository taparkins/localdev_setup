CURRENT_ZSHRC_VERSION=1

if [[ -z "$LOCALDEV_ZSHRC_VERSION" ]]; then
    cat .zshrc >> ~/.zshrc
fi
if [[ "$LOCALDEV_ZSHRC_VERSION" != "$CURRENT_ZSHRC_VERSION" ]]; then
    cp .dircolors ~/.dircolors
    cp .external_rc ~/.external_rc
    source ~/.external_rc
fi
