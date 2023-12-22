local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		'nvim-lua/plenary.nvim',
	},
	{
		'williamboman/mason.nvim',
		config = function()
			require('plugins.config.mason')
		end,
	},
	{
		'jay-babu/mason-nvim-dap.nvim',
		dependencies = {
			{ 'mfussenegger/nvim-dap' },
			{ 'williamboman/mason.nvim' },
			{ 'theHamsta/nvim-dap-virtual-text' },
			{ 'rcarriga/nvim-dap-ui' },
		},
		config = function()
			require('plugins.config.dap')
		end,
	},
	{
		'mfussenegger/nvim-dap',
	},
	{
		'ThePrimeagen/refactoring.nvim',
		config = function()
			require('plugins.config.refactoring')
		end,
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-treesitter/nvim-treesitter' },
		},
	},
	-- AI
	{
		'Exafunction/codeium.vim',
		config = function()
			require('plugins.config.codeium')
		end,
		enabled = false,
	},
	-- Util
	{
		'dstein64/vim-startuptime',
		cmd = 'StartupTime',
	},
	{
		'akinsho/toggleterm.nvim',
		enabled = false,
		config = function()
			require('plugins.config.toggleterm')
		end,
	},
	-- Motions & Objects
	{
		'tpope/vim-surround',
		config = function()
			require('plugins.config.vimSurround')
		end,
		dependencies = {
			'tpope/vim-repeat',
		},
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('plugins.config.Comment')
		end,
	},
	{
		'bkad/CamelCaseMotion',
		config = function()
			require('plugins.config.camelCaseMotions')
		end,
	},
	{
		'phaazon/hop.nvim',
		config = function()
			require('plugins.config.hop')
		end,
	},
	{
		'windwp/nvim-autopairs',
		config = function()
			require('plugins.config.autopairs')
		end,
		-- after = {
		-- 'nvim-cmp',
		-- },
		enabled = false,
	},
	{
		'mattn/emmet-vim',
	},
	-- Git
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('plugins.config.gitsigns')
		end,
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		'tpope/vim-fugitive',
		config = function()
			require('plugins.config.fugitive')
		end,
		cmd = 'Git',
	},
	-- File Management
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			require('plugins.config.telescope')
		end,
		dependencies = {
			{
				'gbrlsnchs/telescope-lsp-handlers.nvim',
			},
			{
				'nvim-lua/plenary.nvim',
			},
			{
				'nvim-telescope/telescope-ui-select.nvim',
			},
		},
	},
	{
		'stevearc/oil.nvim',
		opts = {},
		config = function()
			require('oil').setup({
				default_file_explorer = true,
				view_options = {
					show_hidden = true
				}
			})
			vim.keymap.set(
				'n',
				'-',
				'<CMD>Oil<CR>',
				{ desc = 'Open parent directory' }
			)
		end,
	},
	{
		'kyazdani42/nvim-tree.lua',
		dependencies = {
			{
				'kyazdani42/nvim-web-devicons',
			},
		},
		config = function()
			require('plugins.config.nvimTree')
		end,
	},
	{
		'mbbill/undotree',
		config = function()
			require('plugins.config.undotree')
		end,
	},
	-- LSP, Completion & Formatting
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('lsp')
		end,
		-- after = { 'mason.nvim' },
		dependencies = {
			{
				'williamboman/mason-lspconfig.nvim',
			},
		},
	},
	{
		'simrat39/symbols-outline.nvim',
		config = function()
			require('symbols-outline').setup({
				auto_close = true,
			})
		end,
	},
	{
		'mfussenegger/nvim-lint',
		config = function()
			require('plugins.config.lint')
		end,
	},
	{
		'mhartington/formatter.nvim',
		config = function()
			require('plugins.config.formatter')
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		config = function()
			require('plugins.config.cmp')
		end,
		dependencies = {
			{
				'hrsh7th/vim-vsnip',
				-- after = 'nvim-cmp',
				config = function()
					require('plugins.config.vsnip')
				end,
			},
			{
				'hrsh7th/cmp-vsnip',
			},
			{
				'rafamadriz/friendly-snippets',
			},
			{
				'hrsh7th/cmp-buffer',
			},
			{
				'hrsh7th/cmp-calc',
			},
			{
				'hrsh7th/cmp-cmdline',
			},
			{
				'hrsh7th/cmp-nvim-lsp',
			},
			{
				'hrsh7th/cmp-path',
			},
			{
				'onsails/lspkind-nvim',
			},
		},
	},
	{
		'habamax/vim-godot',
		config = function()
			require('lspconfig').gdscript.setup({
				capabilities = require('cmp_nvim_lsp').default_capabilities(
					vim.lsp.protocol.make_client_capabilities()
				),
			})
		end,
		ft = 'gdscript',
	},
	-- Syntax Highlighting
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('plugins.config.treesitter')
		end,
	},
	{
		'nvim-treesitter/playground',
		dependencies = 'nvim-treesitter/nvim-treesitter',
	},
	-- Theming
	{
		'haishanh/night-owl.vim',
		enabled = false,
	},
	{
		'rebelot/kanagawa.nvim',
		enabled = false,
		name = 'kanagawa',
		config = function()
			require('plugins.colorscheme')
		end,
	},
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		config = function()
			require('plugins.colorscheme')
		end,
	},
	{
		'dracula/vim',
		enabled = false,
		config = function()
			require('plugins.colorscheme')
		end,
		name = 'dracula',
	},
	{
		'folke/tokyonight.nvim'
	},
	{
		'ray-x/aurora',
	},
}

require('lazy').setup(plugins)

-- auto-sync when plugins file is saved
local lazy_user_config_group =
	vim.api.nvim_create_augroup('LazyUserConfig', { clear = true })

-- vim.api.nvim_create_autocmd('BufWritePost', {
-- 	pattern = 'lazy.lua',
-- 	group = lazy_user_config_group,
-- 	command = 'source <afile> | PackerSync',
-- })

-- Keybind to update a plugin hash
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = 'lazy.lua',
	group = lazy_user_config_group,
	callback = function()
		vim.keymap.set('n', '<leader>Up', function()
			-- Delete the current hash and yank the plugin name
			vim.cmd("norm 0f=lD^yi'")
			local plugin_name = vim.fn.getreg('"')
			-- fetch the hash from github
			local hash = require('util').get_plugin_hash(plugin_name)
			-- put the hash back into the " register
			require('util').yank(hash)
			-- Paste the hash and prefix it with a '
			vim.cmd("norm pI'")
			-- Add ', to the end of the hash
			vim.cmd("norm A',")
			-- Join the lines and move down to the next line
			vim.cmd('norm kJj')
		end, { buffer = true })
	end,
})
