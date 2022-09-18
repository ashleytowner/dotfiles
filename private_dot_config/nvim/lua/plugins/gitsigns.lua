require('gitsigns').setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "▁", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "▔", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
})

vim.keymap.set('n', 'gip', '<cmd>Gitsigns preview_hunk<CR>')
vim.keymap.set('n', 'gib', '<cmd>Gitsigns blame_line<CR>')
vim.keymap.set('n', '[g', '<cmd>Gitsigns prev_hunk<CR>')
vim.keymap.set('n', ']g', '<cmd>Gitsigns next_hunk<CR>')
