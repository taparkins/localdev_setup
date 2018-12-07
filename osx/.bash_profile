export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls -GFh'

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

pushd () {
    command pushd "$@" > /dev/null
}
popd () {
    command popd "$@" > /dev/null
}

# If you would like to provide specialized instructions that will not be overwritten by an install,
# put those into ~/.external_profile
if [ -f ~/.external_profile ]; then
    source ~/.external_profile
fi
