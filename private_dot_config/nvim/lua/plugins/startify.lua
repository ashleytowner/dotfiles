vim.cmd([[
  autocmd VimEnter * if !argc() && !len(getqflist())
                      \ | execute 'Startify' 
                      \ | execute 'NvimTreeOpen' 
                      \ | execute 'wincmd w'
                      \ | endif
]])

vim.cmd([[
  autocmd User StartifyBufferOpened NvimTreeClose
]])

vim.g.startify_lists = {
  {
    type = 'dir',
    header = { '  MRU in Directory' }
  },
  {
    type = 'sessions',
    header = { '  Sessions' }
  }
}
