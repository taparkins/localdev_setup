#!/bin/bash

set -e


BINDINGS_FILE=DefaultKeyBinding.dict
BINDINGS_DIR=${HOME}/Library/KeyBindings

if [[ ! -d ${BINDINGS_DIR} ]]; then
    mkdir -p ${BINDINGS_DIR}
fi
if [[ ! -f ${BINDINGS_DIR}/${BINDINGS_FILE} ]]; then
    touch ${BINDINGS_DIR}/${BINDINGS_FILE}
fi

ARE_DIFF=$(diff -q ${BINDINGS_DIR}/${BINDINGS_FILE} ${BINDINGS_FILE})
if [[ ${ARE_DIFF} != "" ]]; then
    cp ${BINDINGS_FILE} ${BINDINGS_DIR}/${BINDINGS_FILE}
    echo "Key Binding differences found -- be sure to restart applications to see effects."
fi
