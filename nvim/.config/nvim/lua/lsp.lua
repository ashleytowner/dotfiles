local tscpOk, tscp = pcall(require, 'telescope.builtin')

local function set_keymaps()
	print("Hello");
	vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Signature help',
	})

	vim.keymap.set(
		'n',
		'K',
		vim.lsp.buf.hover,
		{ noremap = true, silent = true, buffer = true, desc = 'Hover' }
	)

	vim.keymap.set(
		'n',
		'<leader>.',
		vim.lsp.buf.code_action,
		{ noremap = true, silent = true, buffer = true, desc = 'Code action' }
	)

	vim.keymap.set('n', ']t', function()
		if tscpOk then
			tscp.lsp_type_definitions()
		else
			vim.lsp.buf.type_definition()
		end
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to type definition',
	})

	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to previous diagnostic',
	})

	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to next diagnostic',
	})

	vim.keymap.set('n', '<leader>d', function()
		local formatFunction = function(d)
			return '[' .. d.source .. '] '
		end
		vim.diagnostic.open_float(
			nil,
			{ prefix = formatFunction, border = 'rounded' }
		)
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Show diagnostics',
	})

	vim.keymap.set('n', '<leader>D', function()
		if tscpOk then
			tscp.diagnostics({ bufnr = 0 })
		else
			vim.diagnostic.setqflist()
		end
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Show diagnostics',
	})

	vim.keymap.set('n', ']i', vim.lsp.buf.implementation, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to implementation',
	})

	vim.keymap.set('n', '==', function()
		local line = vim.fn.getcurpos()[2]

		vim.lsp.buf.format({
			range = {
				['start'] = { line, 0 },
				['end'] = { line, 10000 },
			},
		})
	end, { noremap = true, silent = true, buffer = true, desc = 'Format line' })

	vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to implementation',
	})

	vim.keymap.set(
		'n',
		'<leader>rn',
		vim.lsp.buf.rename,
		{ noremap = true, silent = true, buffer = true, desc = 'Rename' }
	)

	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to declaration',
	})

	vim.keymap.set('n', '<C-]>', function()
		if tscpOk then
			tscp.lsp_definitions()
		else
			vim.lsp.buf.definition()
		end
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to definition',
	})

	vim.keymap.set('n', ']r', function()
		if tscpOk then
			tscp.lsp_references()
		else
			vim.lsp.buf.references()
		end
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Go to references',
	})

	vim.keymap.set('n', '<leader>sym', function()
		if tscpOk then
			tscp.lsp_document_symbols()
		else
			vim.lsp.buf.document_symbol()
		end
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Document symbols',
	})

	vim.keymap.set('n', '<leader>Sym', function()
		if tscpOk then
			tscp.lsp_dynamic_workspace_symbols()
		else
			vim.lsp.buf.workspace_symbol()
		end
	end, {
		noremap = true,
		silent = true,
		buffer = true,
		desc = 'Workspace symbols',
	})
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('neodev').setup()
local masonLspOk, masonLsp = pcall(require, 'mason-lspconfig')
local lspConfigOk, lspConfig = pcall(require, 'lspconfig')

if not (masonLspOk or lspConfigOk) then
	return
end

vim.lsp.config('*', {
	on_attach = function()
		set_keymaps()
	end
});

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT'
			},
			diagnostics = {
				globals = {
					'vim',
					'require'
				}
			}
		}
	}
})

vim.lsp.config('ts_ls', {
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		set_keymaps()
	end
});

masonLsp.setup({
	ensure_installed = {
		'bashls',
		'clangd',
		'cssls',
		'html',
		'lua_ls',
		'pyright',
		'ts_ls',
		'vimls',
	},
})

local ascii_border = {
	{ '+', 'FloatBorder' },
	{ '-', 'FloatBorder' },
	{ '+', 'FloatBorder' },
	{ '|', 'FloatBorder' },
	{ '+', 'FloatBorder' },
	{ '-', 'FloatBorder' },
	{ '+', 'FloatBorder' },
	{ '|', 'FloatBorder' },
}

vim.diagnostic.config({ float = { border = 'rounded' } })
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = ascii_border,
})

vim.lsp.handlers['textDocument/signatureHelp'] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = ascii_border })

vim.fn.sign_define(
	'DiagnosticSignError',
	{ text = '!', texthl = 'DiagnosticSignError' }
)
vim.fn.sign_define(
	'DiagnosticSignWarn',
	{ text = '?', texthl = 'DiagnosticSignWarn' }
)
vim.fn.sign_define(
	'DiagnosticSignInformation',
	{ text = 'i', texthl = 'DiagnosticSignInformation' }
)
vim.fn.sign_define(
	'DiagnosticSignHint',
	{ text = '~', texthl = 'DiagnosticSignHint' }
)
