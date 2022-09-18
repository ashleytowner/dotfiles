require('nvim-tree').setup({
  open_on_setup = false,
  git = {
    ignore = false
  },
  diagnostics = {
    enable = true
  },
  renderer = {
    highlight_git = true,
    icons = {
      git_placement = "after",
      show = {
        file = true,
        folder = true,
        folder_arrow = false,
        git = true
      },
      glyphs = {
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        }
      }
    }
  }
})
vim.keymap.set(
  'n',
  '<leader><leader>',
  '<cmd>NvimTreeFindFileToggle<cr>',
  { silent = true}
)
