-- Text manipulation
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true })
vim.keymap.set('n', 'n', 'nzz', { noremap = true })
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })

-- Clipboard
vim.keymap.set('', '<leader>P', '"+P', { noremap = true })
vim.keymap.set('', '<leader>Y', '"+y$', { noremap = true })
vim.keymap.set('', '<leader>p', '"+p', { noremap = true })
vim.keymap.set('', '<leader>y', '"+y', { noremap = true })

-- File Navigation
vim.keymap.set('n', '[q', '<cmd>cprev<cr>')
vim.keymap.set('n', ']q', '<cmd>cnext<cr>')
vim.keymap.set('n', '<C-PageDown>', ':bnext<CR>', { noremap = true })
vim.keymap.set('n', '<C-PageUp>', ':bprev<CR>', { noremap = true })
vim.keymap.set('n', 'gw', '<C-w>w', { noremap = true })
vim.keymap.set('n', 'gW', '<C-w>W', { noremap = true })

vim.keymap.set('t', '<C-\\>', '<C-\\><C-n><C-w>w', { noremap = true })
vim.keymap.set('t', '<C-n>', '<C-\\><C-n>', { noremap = true })
