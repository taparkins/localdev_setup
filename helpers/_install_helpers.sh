#!/bin/bash

if [[ ! -e /usr/local/bin/gen_ssh ]]; then
    ln ./gen_ssh/gen_ssh.py /usr/local/bin/gen_ssh
fi
