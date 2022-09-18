require('hop').setup()

vim.keymap.set(
  'n',
  '<leader>w',
  '<cmd>lua require(\'hop\').hint_words({ multi_windows = true })<CR>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>f',
  '<cmd>lua require(\'hop\').hint_char1()<CR>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>s',
  '<cmd>lua require(\'hop\').hint_char2()<cr>',
  { noremap = true }
)
