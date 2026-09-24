local pack_changed_group =
	vim.api.nvim_create_augroup('PackChangedHooks', { clear = true })

vim.api.nvim_create_autocmd('PackChanged', {
	group = pack_changed_group,
	callback = function(event)
		local name = event.data.spec.name
		local kind = event.data.kind

		if
			name == 'nvim-treesitter'
			and (kind == 'install' or kind == 'update')
		then
			if not event.data.active then
				vim.cmd.packadd('nvim-treesitter')
			end

			vim.cmd.TSUpdate()
		end
	end,
})

vim.pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/gbrlsnchs/telescope-lsp-handlers.nvim',
	'https://github.com/nvim-telescope/telescope-ui-select.nvim',
	'https://github.com/tpope/vim-surround',
	'https://github.com/tpope/vim-repeat',
	'https://github.com/numToStr/Comment.nvim',
	'https://github.com/bkad/CamelCaseMotion',
	'https://github.com/smoka7/hop.nvim',
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/tpope/vim-fugitive',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/nvim-tree/nvim-web-devicons',
	'https://github.com/mason-org/mason.nvim',
	'https://github.com/jay-babu/mason-nvim-dap.nvim',
	'https://github.com/mfussenegger/nvim-dap',
	'https://github.com/theHamsta/nvim-dap-virtual-text',
	'https://github.com/rcarriga/nvim-dap-ui',
	'https://github.com/nvim-neotest/nvim-nio',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/neodev.nvim',
	'https://github.com/mason-org/mason-lspconfig.nvim',
	'https://github.com/folke/trouble.nvim',
	'https://github.com/nvimtools/none-ls.nvim',
	'https://github.com/jay-babu/mason-null-ls.nvim',
	'https://github.com/mhartington/formatter.nvim',
	'https://github.com/hrsh7th/nvim-cmp',
	'https://github.com/hrsh7th/vim-vsnip',
	'https://github.com/hrsh7th/cmp-vsnip',
	'https://github.com/rafamadriz/friendly-snippets',
	'https://github.com/hrsh7th/cmp-buffer',
	'https://github.com/hrsh7th/cmp-calc',
	'https://github.com/hrsh7th/cmp-cmdline',
	'https://github.com/hrsh7th/cmp-nvim-lsp',
	'https://github.com/hrsh7th/cmp-path',
	'https://github.com/onsails/lspkind-nvim',
	'https://github.com/hrsh7th/cmp-emoji',
	'https://github.com/habamax/vim-godot',
	{
		src = 'https://github.com/nvim-treesitter/nvim-treesitter',
		version = 'main',
	},
	{
		src = 'https://github.com/catppuccin/nvim',
		name = 'catppuccin',
	},
	'https://github.com/dstein64/vim-startuptime',
}, { confirm = false })

-- Optional plugins distributed with Neovim.
vim.cmd.packadd('nvim.difftool')
vim.cmd.packadd('nvim.tohtml')
vim.cmd.packadd('nvim.undotree')

vim.keymap.set('n', '<leader>u', '<cmd>Undotree<cr>', {
	desc = 'Toggle undo tree',
})

-- Plugin setup is kept separate from installation because vim.pack does not
-- provide configuration callbacks.
local plugin_configs = {
	-- Base
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
						'--hidden',
						'--vimgrep',
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
					mappings = {
						i = {
							['<C-q>'] = require('telescope.actions').smart_send_to_qflist,
						},
					},
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
					live_grep = {
						file_ignore_patterns = {
							'node_modules',
							'.git',
							'.venv',
						},
					},
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
						'-uuu',
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
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			local commentOk, comment = pcall(require, 'Comment')

			if not commentOk then
				print('Comment.nvim is not installed')
			end

			comment.setup()
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
		'smoka7/hop.nvim',
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
					add = { text = '┃' },
					change = { text = '┃' },
					delete = { text = '_' },
					topdelete = { text = '‾' },
					changedelete = { text = '~' },
					untracked = { text = '┆' },
				},
				signs_staged = {
					add = { text = '┃' },
					change = { text = '┃' },
					delete = { text = '_' },
					topdelete = { text = '‾' },
					changedelete = { text = '~' },
					untracked = { text = '┆' },
				},
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = 'single',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1,
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
			vim.keymap.set('n', ']h', function()
				gs.nav_hunk('next')
			end, { desc = 'GitSigns next hunk' })
			vim.keymap.set('n', '[h', function()
				gs.nav_hunk('prev')
			end, { desc = 'GitSigns prev hunk' })
		end,
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
	},
	-- File Management
	{
		'stevearc/oil.nvim',
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
	},
	-- LSP, Completion, Debugging & Formatting
	{
		'mason-org/mason.nvim',
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
		config = function()
			-- setup
			require('mason-nvim-dap').setup({
				ensure_installed = { 'js' },
				automatic_installation = false,
				handlers = {
					function(config)
						require('mason-nvim-dap').default_setup(config)
					end,
				},
			})

			require('nvim-dap-virtual-text').setup({})
			require('dapui').setup()

			local dap = require('dap')
			dap.adapters['pwa-node'] = {
				type = 'server',
				host = 'localhost',
				port = '${port}',
				executable = {
					command = 'js-debug-adapter',
					args = { '${port}' },
				},
			}

			local js_configurations = {
				{
					type = 'pwa-node',
					request = 'launch',
					name = 'Launch current file',
					program = '${file}',
					cwd = '${workspaceFolder}',
				},
				{
					type = 'pwa-node',
					request = 'attach',
					name = 'Attach to process',
					processId = require('dap.utils').pick_process,
					cwd = '${workspaceFolder}',
				},
			}

			for _, language in ipairs({
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
			}) do
				dap.configurations[language] = js_configurations
			end

			-- keymappings

			vim.keymap.set('n', '<F4>', function()
				require('dap').continue()
			end, { desc = 'Debugger: continue' })

			vim.keymap.set('n', '<leader>b', function()
				require('dap').toggle_breakpoint()
			end, { desc = 'Debugger: toggle breakpoint' })

			-- listeners
			require('dap').listeners.after.event_initialized['dapui'] = function()
				require('dapui').open()
			end

			require('dap').listeners.before.event_terminated['dapui'] = function()
				require('dapui').close()
			end

			require('dap').listeners.before.event_exited['dapui'] = function()
				require('dapui').close()
			end

			require('dap').listeners.after.event_initialized['keymaps'] = function()
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

			require('dap').listeners.before.event_terminated['keymaps'] = function()
				vim.o.mouse = ''
			end

			require('dap').listeners.before.event_exited['keymaps'] = function()
				vim.o.mouse = ''
			end
		end,
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			require('lsp')
		end,
	},
	{
		'nvimtools/none-ls.nvim',
		config = function()
			local mason_null_ls = require('mason-null-ls')
			local null_ls = require('null-ls')

			---@diagnostic disable-next-line: missing-fields
			mason_null_ls.setup({
				ensure_installed = {
					'eslint_d',
					'jq',
				},
				automatic_installation = false,
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
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-e>'] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					['<C-l>'] = cmp.mapping(function()
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
					{ name = 'emoji' },
				}),
				formatting = {
					expandable_indicator = true,
					fields = { 'abbr', 'kind', 'menu' },
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

			vim.cmd([[
				imap <expr> <C-l> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-l>'
				smap <expr> <C-l> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-l>'
				imap <expr> <C-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
				smap <expr> <C-h> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-h>'
			]])
		end,
	},
	-- Colours
	{
		'catppuccin/nvim',
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
}

for _, plugin in ipairs(plugin_configs) do
	plugin.config()
end
