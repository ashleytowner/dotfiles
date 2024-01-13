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
	-- Base
	{
		'nvim-lua/plenary.nvim',
	},
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
					file_sorter = require('telescope.sorters').get_fzy_sorter,
					file_ignore_patterns = {},
					generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
					winblend = 0,
					border = true,
					dynamic_preview_title = true,
					borderchars = {
						-- '─',
						-- '│',
						-- '─',
						-- '│',
						-- '╭',
						-- '╮',
						-- '╯',
						-- '╰',
						'-',
						'|',
						'-',
						'|',
						'+',
						'+',
						'+',
						'+',
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

			local builtin = require('telescope.builtin')

			-- Keymaps
			vim.keymap.set(
				'n',
				'<C-f>',
				builtin.live_grep,
				{ noremap = true, desc = 'Telescope live grep' }
			)

			vim.keymap.set('n', '<leader>*', builtin.grep_string, {
				noremap = true,
				desc = 'Telescope grep word under cursor or selection',
			})

			vim.keymap.set(
				'n',
				'<C-p>',
				builtin.find_files,
				{ noremap = true, desc = 'Telescope find files' }
			)

			vim.keymap.set('n', '<C-M-p>', function()
				builtin.find_files({
					find_command = {
						'rg',
						'--hidden',
						'--files',
					},
				})
			end, { noremap = true, desc = 'Telescope find files' })

			vim.keymap.set(
				'n',
				'<leader>tq',
				builtin.quickfix,
				{ noremap = true, desc = 'Telescope quickfix' }
			)

			vim.keymap.set(
				'n',
				'<leader>tg',
				builtin.git_branches,
				{ noremap = true, desc = 'Telescope git branches' }
			)

			vim.keymap.set(
				'n',
				'<leader>tp',
				builtin.resume,
				{ noremap = true, desc = 'Show previous telescope popup' }
			)

			vim.keymap.set(
				'n',
				'<leader>tc',
				builtin.colorscheme,
				{ noremap = true, desc = 'Telescope pick colorscheme' }
			)

			vim.keymap.set(
				'n',
				'<leader>ls',
				builtin.buffers,
				{ noremap = true, desc = 'Telescope buffers' }
			)

			vim.keymap.set('n', '<leader>todo', function()
				builtin.live_grep({
					default_text = '(TODO|NOTE|BUG|HACK|WARN|WARNING)(\\(\\w+\\))?:',
				})
			end, { noremap = true, desc = 'Telescope TODOs' })
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
	-- Motions & Objects
	{
		'tpope/vim-surround',
		config = function()
			vim.keymap.set(
				'n',
				'SS',
				'<Plug>YSsurround',
				{ silent = true, desc = 'Surround around line' }
			)
			vim.keymap.set(
				'n',
				'Ss',
				'<Plug>YSsurround',
				{ silent = true, desc = 'Surround around line' }
			)
			vim.keymap.set(
				'n',
				'ss',
				'<Plug>Yssurround',
				{ silent = true, desc = 'Surround in line' }
			)
			vim.keymap.set('n', 'S', '<Plug>YSurround', {
				silent = true,
				desc = 'Start surround around operation, accepts a motion',
			})
			vim.keymap.set('n', 's', '<Plug>Ysurround', {
				silent = true,
				desc = 'Start surround operation, accepts a motion',
			})
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
			vim.keymap.set(
				'',
				',w',
				'<Plug>CamelCaseMotion_w',
				{ desc = 'CamelCaseMotion w' }
			)
			vim.keymap.set(
				'',
				',b',
				'<Plug>CamelCaseMotion_b',
				{ desc = 'CamelCaseMotion b' }
			)
			vim.keymap.set(
				'',
				',e',
				'<Plug>CamelCaseMotion_e',
				{ desc = 'CamelCaseMotion e' }
			)
			vim.keymap.set(
				'',
				'g,e',
				'<Plug>CamelCaseMotion_ge',
				{ desc = 'CamelCaseMotion ge' }
			)
			vim.keymap.set(
				{ 'x', 'o' },
				'i,w',
				'<Plug>CamelCaseMotion_iw',
				{ desc = 'CamelCaseMotion iw' }
			)
			vim.keymap.set(
				{ 'x', 'o' },
				'i,b',
				'<Plug>CamelCaseMotion_ib',
				{ desc = 'CamelCaseMotion ib' }
			)
			vim.keymap.set(
				{ 'x', 'o' },
				'i,e',
				'<Plug>CamelCaseMotion_ie',
				{ desc = 'CamelCaseMotion ie' }
			)
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
			end, { noremap = true, desc = 'Hop words' })

			vim.keymap.set('n', '<leader>f', function()
				require('hop').hint_char1()
			end, { noremap = true, desc = 'Hop character' })

			vim.keymap.set('n', '<leader>s', function()
				require('hop').hint_char2({
					hint_position = require('hop.hint').HintPosition.END,
					hint_offset = -1,
				})
			end, { noremap = true, desc = 'Hop 2 characters' })
		end,
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

			vim.keymap.set(
				'n',
				'gsh',
				gs.preview_hunk,
				{ desc = 'GitSigns preview hunk' }
			)
			vim.keymap.set('n', 'gsb', function()
				gs.blame_line({ full = true })
			end, { desc = 'GitSigns blame line' })
			vim.keymap.set(
				'n',
				'gss',
				gs.stage_hunk,
				{ desc = 'GitSigns stage hunk' }
			)
			vim.keymap.set(
				'n',
				'gsS',
				gs.undo_stage_hunk,
				{ desc = 'GitSigns undo stage hunk' }
			)
			vim.keymap.set(
				'n',
				']h',
				gs.next_hunk,
				{ desc = 'GitSigns next hunk' }
			)
			vim.keymap.set(
				'n',
				'[h',
				gs.prev_hunk,
				{ desc = 'GitSigns prev hunk' }
			)
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
				{ noremap = true, desc = 'Git diff split' }
			)
		end,
		cmd = 'Git',
	},
	-- File Management
	{
		'stevearc/oil.nvim',
		-- We lazy load oil on BufEnter so that netrw can still handle
		-- scp://, ftp:// etc because oil handles them weirdly
		event = 'BufEnter',
		config = function()
			require('oil').setup({
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set(
				'n',
				'-',
				require('oil').open,
				{ desc = 'Open parent directory' }
			)
		end,
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
	},
	{
		'nvim-tree/nvim-tree.lua',
		lazy = true,
		dependencies = {
			{
				'nvim-tree/nvim-web-devicons',
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
			vim.keymap.set(
				'n',
				'<leader>u',
				'<CMD>UndotreeToggle<CR>',
				{ desc = 'Toggle undotree' }
			)
		end,
	},
	-- AI
	{
		'Exafunction/codeium.vim',
		cond = function()
			return os.getenv('NO_AI') ~= 'true'
		end,
		config = function()
			vim.g.codeium_disable_bindings = true
			vim.g.ai = 'codeium'

			vim.keymap.set(
				'i',
				'<C-g>n',
				'<CMD>call codeium#CycleCompletions(1)<CR>',
				{ noremap = true, desc = 'Cycle to next codeium completion' }
			)

			vim.keymap.set(
				'i',
				'<C-g>p',
				'<CMD>call codeium#CycleCompletions(-1)<CR>',
				{
					noremap = true,
					desc = 'Cycle to previous codeium completion',
				}
			)

			vim.keymap.set(
				'i',
				'<C-g><CR>',
				'<CMD>call codeium#Accept()<CR>',
				{ noremap = true, desc = 'Accept codeium completion' }
			)

			vim.keymap.set(
				'i',
				'<C-g><C-e>',
				'<CMD>call codeium#Clear()<CR>',
				{ noremap = true, desc = 'Clear codeium completion' }
			)
		end,
	},
	-- LSP, Completion, Debugging & Formatting
	{
		'mattn/emmet-vim',
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
			end, { desc = 'Debugger: continue' })

			vim.keymap.set('n', '<leader>b', function()
				require('dap').toggle_breakpoint()
			end, { desc = 'Debugger: toggle breakpoint' })

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
				end, { desc = 'Debugger: step over' })
				vim.keymap.set('n', '<F2>', function()
					require('dap').step_into()
				end, { desc = 'Debugger: step into' })
				vim.keymap.set('n', '<F12>', function()
					require('dap').step_out()
				end, { desc = 'Debugger: step out' })
				vim.keymap.set('n', '<C-c>', function()
					require('dap').terminate()
				end, { desc = 'Debugger: terminate' })
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
		'neovim/nvim-lspconfig',
		config = function()
			require('lsp')
		end,
		dependencies = {
			{
				'folke/neodev.nvim',
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
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},
	{
		'nvimtools/none-ls.nvim',
		dependencies = { 'mason.nvim', 'jay-babu/mason-null-ls.nvim' },
		config = function()
			local mason_null_ls = require('mason-null-ls')
			local null_ls = require('null-ls')

			mason_null_ls.setup({
				ensure_installed = {
					'eslint_d',
					'jq',
				},
				handlers = {
					function(source, methods)
						require('mason-null-ls.automatic_setup')(
							source,
							methods
						)
					end,
					['eslint_d'] = function(source, methods)
						-- Check if an eslint config file exists before starting eslint
						if vim.fn.glob('.eslintrc*') ~= '' then
							require('mason-null-ls.automatic_setup')(
								source,
								methods
							)
						end
					end,
				},
			})

			null_ls.setup()
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
			end, { noremap = true, silent = true, desc = 'Format file' })
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
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' },
				},
			})
		end,
		dependencies = {
			{
				'hrsh7th/vim-vsnip',
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
		build = ':TSUpdate',
		config = function()
			local parser_config =
				require('nvim-treesitter.parsers').get_parser_configs()
			parser_config.typescript.filetype_to_parsername = 'javascript.jsx'

			require('nvim-treesitter.configs').setup({
				ensure_installed = 'all', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
	-- Colours
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		lazy = true,
		config = function()
			require('catppuccin').setup({
				background = {
					light = 'latte',
					dark = 'macchiato',
				},
				show_end_of_buffer = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					treesitter = true,
					hop = true,
					mason = true,
					markdown = true,
					dap = true,
					telescope = {
						enabled = true,
						-- style = 'nvchad',
					},
				},
			})
		end,
	},
	{
		'rose-pine/neovim',
		name = 'rose-pine',
		lazy = true,
		config = function()
			require('rose-pine').setup({
				variant = 'moon',
				dark_variant = 'moon',
				disable_italics = false,
			})
		end,
	},
	{
		'folke/tokyonight.nvim',
		lazy = true,
	},
	{
		'ray-x/aurora',
		lazy = true,
	},
	{
		'rafamadriz/neon',
		lazy = true,
	},
	-- Util
	{
		'dstein64/vim-startuptime',
		cmd = 'StartupTime',
	},
}

require('lazy').setup(plugins)
