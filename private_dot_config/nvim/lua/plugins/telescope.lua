local telescope = require('telescope')
telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--no-ignore-vcs'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    dynamic_preview_title = true,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = { "truncate" },
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  },
  extensions = {
    'refactoring',
    ['ui-select'] = {
      require('telescope.themes').get_cursor()
    }
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      no_ignore = true,
      hidden = true,
      type = 'f',
      previewer = false
    },
    git_branches = {
      theme = "dropdown"
    },
    buffers = {
      theme = "dropdown"
    },
    live_grep = {
      theme = "dropdown"
    },
    lsp_references = {
      theme = "cursor"
    },
    lsp_definitions = {
      theme = "cursor"
    },
    quickfix = {
      theme = "ivy"
    },
    loclist = {
      theme = "ivy"
    },
    diagnostics = {
      theme = "ivy"
    }
  }
}

-- Extensions
telescope.load_extension('ui-select');
telescope.load_extension('refactoring');

-- Keymaps
vim.keymap.set('n', '<C-f>', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.keymap.set(
  'n',
  '<C-p>',
  '<cmd>Telescope find_files<cr>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>qf',
  '<cmd>Telescope quickfix<cr>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>gco',
  '<cmd>Telescope git_branches<cr>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>ls',
  '<cmd>Telescope buffers<cr>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>ts',
  '<cmd>Telescope treesitter<cr>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>d',
  '<cmd>Telescope diagnostics<cr>',
  { noremap = true }
)
vim.keymap.set(
  'v',
  '<leader>rr',
  '<esc><cmd>lua require(\'telescope\').extensions.refactoring.refactors()<CR>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>tp',
  '<cmd>Telescope resume<cr>',
  { noremap = true }
)
vim.keymap.set(
  'n',
  '<leader>cs',
  '<cmd>Telescope colorscheme<CR>',
  { noremap = true}
)
