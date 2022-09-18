vim.api.nvim_exec([[
let $LOCALFILE=expand("~/.config/local_override/nvim/init.vim")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
]], false)

vim.api.nvim_exec([[
let $REPOCONFIG=expand('./.vim/init.vim')
if filereadable($REPOCONFIG)
  source $REPOCONFIG
endif
]], false)
