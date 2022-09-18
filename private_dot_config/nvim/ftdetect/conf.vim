" If a hidden file ends with rc or ignore, it's probably a config file

if &filetype == '' && (@% =~ '\..\+rc$' || @% =~ '\..\+ignore$')
    set ft=conf
endif
