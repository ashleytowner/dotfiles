vim.g.mapleader = ' '

require('plugins')
Util = require('util')
require('lines')

--- colorscheme
require('catppuccin').setup({
	background = {
		light = "latte",
		dark = "macchiato"
	},
	show_end_of_buffer = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		hop = true,
		mason = true,
		nvimtree = true,
		telescope = {
			enabled = true,
			style = 'nvchad'
		}
	}
})

vim.cmd([[colorscheme catppuccin]])

-- highlight text on yank
local yank_highlight_group =
	vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	pattern = '*',
	group = yank_highlight_group,
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 100,
		})
	end,
})

---Get the text for a foldline
---@return string
function FoldText()
	return ' '
		.. vim.fn.getline(vim.v.foldstart)
		.. ' ('
		.. (vim.v.foldend - vim.v.foldstart)
		.. ' lines)'
end

-- Define some symbols which can also be treated as wrappers around textobjects
Util.create_wrapped_textobject('*')
Util.create_wrapped_textobject('/')
Util.create_wrapped_textobject('.')
Util.create_wrapped_textobject('_')
Util.create_wrapped_textobject('|')
Util.create_wrapped_textobject('$')
Util.create_wrapped_textobject('#')

vim.o.expandtab = false
vim.o.wildignore = 'node_modules/*'
vim.o.foldlevel = 99
vim.o.hlsearch = false
vim.o.showbreak='↪\\'
vim.o.listchars = 'tab:▎ ,trail:·,nbsp:␣,extends:⟩,precedes:⟨'
vim.o.number = true
vim.o.pyxversion = 3
vim.o.relativenumber = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.wo.cursorline = true
vim.wo.colorcolumn = '80'
vim.wo.list = true
vim.wo.wrap = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.signcolumn = 'auto:3-9'
vim.go.statusline = '%!v:lua.StatusLine()'
vim.go.tabline = '%!v:lua.TabLine()'
vim.go.showtabline = 2
vim.o.shell = '/bin/zsh'
vim.o.mouse = ''
vim.go.splitbelow = true
vim.go.splitright = true
vim.o.foldtext = 'v:lua.FoldText()'

vim.g.markdown_fenced_languages = {
	'ts=typescript',
	'tsx=typescriptreact',
	'zsh=zsh',
	'sh=sh',
	'bash=bash',
	'js=javascript',
}

vim.cmd('filetype on')
vim.cmd('filetype plugin on')
vim.cmd('syntax enable')

require('keymaps')

if (vim.g.neovide) then
	vim.o.guifont = 'JetBrains Mono:h18'
end

--- Setup for machine-specific configurations
vim.api.nvim_exec(
	[[
let $LOCALFILE=expand("~/.config/local_override/nvim/init.vim")
if filereadable($LOCALFILE)
	source $LOCALFILE
endif
]],
	false
)

vim.api.nvim_exec(
	[[
let $REPOCONFIG=expand('./.vim/init.vim')
if filereadable($REPOCONFIG)
	source $REPOCONFIG
endif
]],
	false
)
