set number

" Wrap is terrible, so I'm disabling it :P
set whichwrap=""

" This should let us use the OSX clipboard for the base yank/paste register
if has("clipboard")
    set clipboard=unnamed
endif
