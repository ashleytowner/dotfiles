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
			local masonOk, mason = pcall(require, 'mason')

			if not masonOk then
				print("Mason couldn't be loaded!")
				return
			end

			mason.setup()
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
			-- setup
			require('mason-nvim-dap').setup({
				ensure_installed = { 'node2' },
				handlers = {
					function(config)
						require('mason-nvim-dap').default_setup(config)
					end,
				},
			})

			require('nvim-dap-virtual-text').setup()
			require('dapui').setup()

			-- keymappings

			vim.keymap.set('n', '<F4>', function()
				require('dap').continue()
			end)

			vim.keymap.set('n', '<leader>b', function()
				require('dap').toggle_breakpoint()
			end)

			-- listeners
			require('dap').listeners.after.event_initialized['dapui'] = function(
			)
				require('dapui').open()
			end

			require('dap').listeners.before.event_terminated['dapui'] = function(
			)
				require('dapui').close()
			end

			require('dap').listeners.before.event_exited['dapui'] = function()
				require('dapui').close()
			end

			require('dap').listeners.after.event_initialized['keymaps'] = function(
			)
				vim.o.mouse = 'nv'
				vim.keymap.set('n', '<F3>', function()
					require('dap').step_over()
				end)
				vim.keymap.set('n', '<F2>', function()
					require('dap').step_into()
				end)
				vim.keymap.set('n', '<F12>', function()
					require('dap').step_out()
				end)
				vim.keymap.set('n', '<C-c>', function()
					require('dap').terminate()
				end)
			end

			require('dap').listeners.before.event_terminated['keymaps'] = function(
			)
				vim.o.mouse = ''
			end

			require('dap').listeners.before.event_exited['keymaps'] = function()
				vim.o.mouse = ''
			end
		end,
	},
	{
		'mfussenegger/nvim-dap',
	},
	{
		'ThePrimeagen/refactoring.nvim',
		config = function()
			require('refactoring').setup()

			vim.keymap.set('n', '<leader>rp', function()
				require('refactoring').debug.printf({ below = true })
			end, {
				noremap = true,
				desc = 'Add a printf statement below current line',
			})

			vim.keymap.set('n', '<leader>rP', function()
				require('refactoring').debug.printf({ below = false })
			end, {
				noremap = true,
				desc = 'Add a printf statement above current line',
			})
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
			vim.g.codeium_disable_bindings = true
			vim.g.ai = 'codeium'

			vim.keymap.set(
				'i',
				'<C-g>n',
				'<CMD>call codeium#CycleCompletions(1)<CR>',
				{ noremap = true }
			)

			vim.keymap.set(
				'i',
				'<C-g>p',
				'<CMD>call codeium#CycleCompletions(-1)<CR>',
				{ noremap = true }
			)

			vim.keymap.set(
				'i',
				'<C-g><CR>',
				'<CMD>call codeium#Accept()<CR>',
				{ noremap = true }
			)

			vim.keymap.set(
				'i',
				'<C-g><C-e>',
				'<CMD>call codeium#Clear()<CR>',
				{ noremap = true }
			)
		end
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
			require('toggleterm').setup({
				open_mapping = [[<C-\>]],
				direction = 'float',
			})
		end,
	},
	-- Motions & Objects
	{
		'tpope/vim-surround',
		config = function()
			vim.keymap.set('n', 'SS', '<Plug>YSsurround', { silent = true })
			vim.keymap.set('n', 'Ss', '<Plug>YSsurround', { silent = true })
			vim.keymap.set('n', 'ss', '<Plug>Yssurround', { silent = true })
			vim.keymap.set('n', 'S', '<Plug>YSurround', { silent = true })
			vim.keymap.set('n', 's', '<Plug>Ysurround', { silent = true })
		end,
		dependencies = {
			'tpope/vim-repeat',
		},
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			local commentOk, comment = pcall(require, 'Comment')

			if not commentOk then
				print('Comment.nvim is not installed')
			end

			comment.setup({})
		end,
	},
	{
		'bkad/CamelCaseMotion',
		config = function()
			vim.keymap.set('', ',w', '<Plug>CamelCaseMotion_w')
			vim.keymap.set('', ',b', '<Plug>CamelCaseMotion_b')
			vim.keymap.set('', ',e', '<Plug>CamelCaseMotion_e')
			vim.keymap.set('', 'g,e', '<Plug>CamelCaseMotion_ge')
			vim.keymap.set({ 'x', 'o' }, 'i,w', '<Plug>CamelCaseMotion_iw')
			vim.keymap.set({ 'x', 'o' }, 'i,b', '<Plug>CamelCaseMotion_ib')
			vim.keymap.set({ 'x', 'o' }, 'i,e', '<Plug>CamelCaseMotion_ie')
		end,
	},
	{
		'phaazon/hop.nvim',
		config = function()
			require('hop').setup({
				reverse_distribution = true,
				multi_windows = true,
				keys = 'asdfghjkl;qwertyuiop',
			})

			vim.keymap.set('n', '<leader>w', function()
				require('hop').hint_words()
			end, { noremap = true })

			vim.keymap.set('n', '<leader>f', function()
				require('hop').hint_char1()
			end, { noremap = true })

			vim.keymap.set('n', '<leader>s', function()
				require('hop').hint_char2({
					hint_position = require('hop.hint').HintPosition.END,
					hint_offset = -1,
				})
			end, { noremap = true })
		end,
	},
	{
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup({
				disable_in_macro = true,
			})

			-- set up auto pairs on cmp completions
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local cmp_err, cmp = pcall(require, 'cmp')
			if not cmp_err then
				cmp.event:on(
					'confirm_done',
					cmp_autopairs.on_confirm_done({ map_char = { tex = '' } })
				)

				cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = 'racket'
			end
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
			local gs = require('gitsigns')
			gs.setup({
				signs = {
					add = {
						hl = 'GitSignsAdd',
						text = '▎',
						numhl = 'GitSignsAddNr',
						linehl = 'GitSignsAddLn',
					},
					change = {
						hl = 'GitSignsChange',
						text = '▎',
						numhl = 'GitSignsChangeNr',
						linehl = 'GitSignsChangeLn',
					},
					delete = {
						hl = 'GitSignsDelete',
						text = '▁',
						numhl = 'GitSignsDeleteNr',
						linehl = 'GitSignsDeleteLn',
					},
					topdelete = {
						hl = 'GitSignsDelete',
						text = '▔',
						numhl = 'GitSignsDeleteNr',
						linehl = 'GitSignsDeleteLn',
					},
					changedelete = {
						hl = 'GitSignsChange',
						text = '▎',
						numhl = 'GitSignsChangeNr',
						linehl = 'GitSignsChangeLn',
					},
				},
				current_line_blame = false,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol',
					delay = 0,
				},
			})

			vim.keymap.set('n', 'gsh', gs.preview_hunk)
			vim.keymap.set('n', 'gsb', function()
				gs.blame_line({ full = true })
			end)
			vim.keymap.set('n', 'gss', gs.stage_hunk)
			vim.keymap.set('n', 'gsS', gs.undo_stage_hunk)
			vim.keymap.set('n', ']h', gs.next_hunk)
			vim.keymap.set('n', '[h', gs.prev_hunk)
		end,
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		'tpope/vim-fugitive',
		config = function()
			vim.keymap.set(
				'n',
				'gim',
				'<cmd>Gvdiffsplit!<cr>',
				{ noremap = true }
			)
		end,
		cmd = 'Git',
	},
	-- File Management
	{
		'nvim-telescope/telescope.nvim',
		config = function()
			local telescopeOk, telescope = pcall(require, 'telescope')

			if not telescopeOk then
				return
			end

			telescope.setup({
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
					},
					prompt_prefix = '> ',
					selection_caret = '> ',
					entry_prefix = '  ',
					initial_mode = 'insert',
					selection_strategy = 'reset',
					sorting_strategy = 'descending',
					layout_strategy = 'horizontal',
					layout_config = {
						horizontal = {
							mirror = false,
							width = 0.9,
						},
						vertical = {
							mirror = false,
						},
					},
					file_sorter = require('telescope.sorters').get_fuzzy_file,
					file_ignore_patterns = {},
					generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
					winblend = 0,
					border = true,
					dynamic_preview_title = true,
					borderchars = {
						'─',
						'│',
						'─',
						'│',
						'╭',
						'╮',
						'╯',
						'╰',
					},
					color_devicons = true,
					use_less = true,
					path_display = { 'truncate' },
					set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
					file_previewer = require('telescope.previewers').vim_buffer_cat.new,
					grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
					qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

					-- Developer configurations: Not meant for general override
					buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
				},
				extensions = {
					'refactoring',
					['ui-select'] = {
						require('telescope.themes').get_cursor(),
					},
				},
				pickers = {
					find_files = {
						find_command = {
							'rg',
							'--files',
							'--hidden',
							'--glob',
							'!.git/',
						},
					},
					git_branches = {
						theme = 'dropdown',
					},
					buffers = {},
					live_grep = {},
					lsp_references = {},
					lsp_definitions = {},
					quickfix = {
						theme = 'ivy',
					},
					loclist = {
						theme = 'ivy',
					},
					diagnostics = {
						theme = 'ivy',
					},
				},
			})

			-- Extensions
			telescope.load_extension('ui-select')
			telescope.load_extension('refactoring')

			local builtin = require('telescope.builtin')

			-- Keymaps
			vim.keymap.set('n', '<C-f>', builtin.live_grep, { noremap = true })

			vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true })

			vim.keymap.set('n', '<C-M-p>', function()
				builtin.find_files({
					find_command = {
						'rg',
						'--hidden',
						'--files',
					},
				})
			end, { noremap = true })

			vim.keymap.set(
				'n',
				'<leader>tq',
				builtin.quickfix,
				{ noremap = true }
			)

			vim.keymap.set(
				'n',
				'<leader>tg',
				builtin.git_branches,
				{ noremap = true }
			)

			vim.keymap.set(
				'n',
				'<leader>tb',
				builtin.buffers,
				{ noremap = true }
			)

			vim.keymap.set(
				{ 'x', 'n' },
				'<leader>rr',
				require('telescope').extensions.refactoring.refactors,
				{ noremap = true }
			)

			vim.keymap.set(
				'n',
				'<leader>tp',
				builtin.resume,
				{ noremap = true }
			)

			vim.keymap.set(
				'n',
				'<leader>tc',
				builtin.colorscheme,
				{ noremap = true }
			)

			vim.keymap.set(
				'n',
				'<leader>ls',
				builtin.buffers,
				{ noremap = true }
			)

			vim.keymap.set('n', '<leader>todo', function()
				builtin.live_grep({
					default_text = '(TODO|NOTE|BUG|HACK|WARN|WARNING)(\\(\\w+\\))?:',
				})
			end, { noremap = true })
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
				default_file_explorer = false,
				view_options = {
					show_hidden = true,
				},
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
			require('nvim-tree').setup({
				git = {
					ignore = false,
				},
				diagnostics = {
					enable = true,
				},
				view = {
					side = 'right',
				},

				renderer = {
					highlight_git = true,
					icons = {
						git_placement = 'after',
						show = {
							file = true,
							folder = true,
							folder_arrow = false,
							git = true,
						},
						glyphs = {
							git = {
								unstaged = '!',
								staged = '+',
								unmerged = '',
								renamed = '➜',
								untracked = '?',
								deleted = '',
								ignored = '◌',
							},
						},
					},
				},
			})

			vim.keymap.set(
				'n',
				'<leader><leader>',
				'<cmd>NvimTreeFindFileToggle<cr>',
				{ noremap = true, desc = 'open nvim tree' }
			)
		end,
	},
	{
		'mbbill/undotree',
		config = function()
			vim.keymap.set('n', '<leader>u', '<CMD>UndotreeToggle<CR>')
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
			local lint = require('lint')

			lint.linters_by_ft = {
				typescript = { 'eslint_d' },
				typescriptreact = { 'eslint_d' },
				javascript = { 'eslint_d' },
				javascriptreact = { 'eslint_d' },
				-- css = { 'stylelint' },
				-- scss = { 'stylelint' },
			}

			local lint_group =
				vim.api.nvim_create_augroup('Linters', { clear = true })

			vim.api.nvim_create_autocmd(
				{ 'BufEnter', 'TextChanged', 'InsertLeave' },
				{
					callback = function()
						lint.try_lint()
					end,
					group = lint_group,
				}
			)
		end,
	},
	{
		'mhartington/formatter.nvim',
		config = function()
			local config = {
				logging = false,
				filetype = {
					javascript = require('formatter.filetypes.javascript').prettierd,
					javascriptreact = require(
						'formatter.filetypes.javascriptreact'
					).prettierd,
					typescript = require('formatter.filetypes.typescript').prettierd,
					typescriptreact = require(
						'formatter.filetypes.typescriptreact'
					).prettierd,
					html = require('formatter.filetypes.html').prettierd,
					json = require('formatter.filetypes.json').jq,
					lua = require('formatter.filetypes.lua').stylua,
					css = require('formatter.filetypes.css').prettierd,
					scss = require('formatter.filetypes.css').prettierd,
					python = require('formatter.filetypes.python').black,
				},
			}

			require('formatter').setup(config)

			local function has_formatter()
				local ft = vim.bo.filetype
				for k, _ in pairs(config.filetype) do
					if ft == k then
						return true
					end
				end
			end

			vim.keymap.set('n', 'g=', function()
				if has_formatter() then
					vim.cmd('Format')
				else
					vim.lsp.buf.format()
				end
			end, { noremap = true, silent = true })
		end,
	},
	{
		'hrsh7th/nvim-cmp',
		config = function()
			local lspkind = require('lspkind')

			lspkind.init()

			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn['vsnip#anonymous'](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-d>'] = cmp.mapping(
						cmp.mapping.scroll_docs(-1),
						{ 'i', 'c' }
					),
					['<C-f>'] = cmp.mapping(
						cmp.mapping.scroll_docs(1),
						{ 'i', 'c' }
					),
					['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
					['<C-e>'] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-g><CR>'] = cmp.mapping(function()
						if vim.g.ai == 'copilot' then
							vim.api.nvim_feedkeys(
								vim.fn['copilot#Accept'](
									vim.api.nvim_replace_termcodes(
										'<CR>',
										true,
										true,
										false
									)
								),
								'n',
								false
							)
						end
						if vim.g.ai == 'codeium' then
							vim.api.nvim_feedkeys(
								vim.fn['codeium#Accept'](),
								'n',
								false
							)
						end
					end),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'vsnip' },
					{ name = 'calc' },
				}),
				formatting = {
					format = lspkind.cmp_format({
						with_text = false,
						menu = {
							buffer = '[buf]',
							nvim_lsp = '[LSP]',
							path = '[path]',
							calc = '[calc]',
							vsnip = '[vsnip]',
						},
					}),
				},
				experimental = {
					ghost_text = false,
				},
			})
		end,
		dependencies = {
			{
				'hrsh7th/vim-vsnip',
				-- after = 'nvim-cmp',
				config = function()
					vim.cmd([[
						imap <expr> <C-l> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-l>'
						smap <expr> <C-l> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-l>'
						imap <expr> <C-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
						smap <expr> <C-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
					]])
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
			local parser_config =
				require('nvim-treesitter.parsers').get_parser_configs()
			parser_config.typescript.filetype_to_parsername = 'javascript.jsx'

			require('nvim-treesitter.configs').setup({
				-- ensure_installed = 'all', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
				ensure_installed = {
					'javascript',
					'typescript',
					'c',
					'cpp',
					'gitcommit',
					'lua',
					'yaml',
					'json',
					'toml',
					'markdown',
					'rust',
					'jsdoc',
					'comment',
					'tsx',
				},
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = 'gnn',
						node_incremental = 'grn',
						scope_incremental = 'grc',
						node_decremental = 'grm',
					},
				},
				indent = {
					enable = true,
				},
			})

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
		name = 'kanagawa'
	},
	{
		'catppuccin/nvim',
		name = 'catppuccin'
	},
	{
		'dracula/vim',
		enabled = false,
		name = 'dracula'
	},
	{
		'folke/tokyonight.nvim',
	},
	{
		'ray-x/aurora',
	},
}

require('lazy').setup(plugins)
