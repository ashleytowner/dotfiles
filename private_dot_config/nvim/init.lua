vim.g.mapleader=' '

Util = require('util')
require('plugins')
require('statusline')
require('tabline')

-- auto-sync when plugins file is saved
local packer_user_config_group = vim.api.nvim_create_augroup("PackerUserConfig", { clear = true });
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "packer.lua",
  group = packer_user_config_group,
  command = "source <afile> | PackerSync"
})

-- {{{ Settings
vim.o.expandtab = true
vim.o.wildignore = 'node_modules/*'
vim.o.foldlevel = 99
vim.o.hlsearch = false
vim.o.listchars = 'tab: ,trail:·,nbsp:░'
vim.o.number = true
vim.o.pyxversion = 3
vim.o.relativenumber =  true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.tabstop = 3
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.wo.cursorline = true
vim.wo.colorcolumn = '80'
vim.wo.list = true
vim.wo.wrap = false
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.signcolumn='auto:1-9'
vim.go.statusline = '%!v:lua.StatusLine()'
vim.go.tabline='%!v:lua.TabLine()'
vim.go.showtabline = 2

vim.g.markdown_fenced_languages = {
  "ts=typescript",
  "zsh=zsh",
  "sh=sh",
  "bash=bash",
  "js=javascript"
}

vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('syntax enable')

-- }}}

require('consistentSessions')
require('keymaps')
require('setupLocalConfigs')
