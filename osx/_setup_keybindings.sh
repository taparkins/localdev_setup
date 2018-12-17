#!/bin/bash

BINDINGS_FILE=DefaultKeyBinding.dict
BINDINGS_DIR=~/Library/KeyBindings

if [[ ! -f ${BINDINGS_DIR}/${BINDINGS_FILE} ]]; then
    mkdir -p ${BINDINGS_DIR} && touch ${BINDINGS_FILE}
fi

ARE_DIFF=$(diff -q ${BINDINGS_DIR}/${BINDINGS_FILE} ${BINDINGS_FILE})
if [[ ${ARE_DIFF} != "" ]]; then
    cp ${BINDINGS_FILE} ${BINDINGS_DIR}/${BINDINGS_FILE}
    echo "Key Binding differences found -- be sure to restart applications to see effects."
fi
