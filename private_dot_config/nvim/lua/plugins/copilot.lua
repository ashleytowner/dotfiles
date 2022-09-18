vim.keymap.set(
  'i',
  '<C-g>n',
  '<Plug>(copilot-next)',
  { noremap = true }
)

vim.keymap.set(
  'i',
  '<C-g>p',
  '<Plug>(copilot-prev)',
  { noremap = true }
)

vim.keymap.set(
  'i',
  '<C-g><CR>',
  'copilot#Accept("<CR>")',
  { noremap = true, silent = true, expr = true, script = true }
)
vim.g.copilot_no_tab_map = true
