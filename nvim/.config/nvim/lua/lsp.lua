local tscpOk, tscp = pcall(require, 'telescope.builtin')

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

local function set_keymaps(bufnr)
	vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
		vim.lsp.buf.signature_help({ border = ascii_border })
	end, {
		noremap = true,
		silent = true,
		buf = bufnr,
		desc = 'Signature help',
	})

	vim.keymap.set(
		'n',
		'K',
		function()
			vim.lsp.buf.hover({ border = ascii_border })
		end,
		{ noremap = true, silent = true, buf = bufnr, desc = 'Hover' }
	)

	vim.keymap.set(
		'n',
		'<leader>.',
		vim.lsp.buf.code_action,
		{ noremap = true, silent = true, buf = bufnr, desc = 'Code action' }
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
		buf = bufnr,
		desc = 'Go to type definition',
	})

	vim.keymap.set('n', '[d', function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, {
		noremap = true,
		silent = true,
		buf = bufnr,
		desc = 'Go to previous diagnostic',
	})

	vim.keymap.set('n', ']d', function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, {
		noremap = true,
		silent = true,
		buf = bufnr,
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
		buf = bufnr,
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
		buf = bufnr,
		desc = 'Show diagnostics',
	})

	vim.keymap.set('n', ']i', vim.lsp.buf.implementation, {
		noremap = true,
		silent = true,
		buf = bufnr,
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
	end, { noremap = true, silent = true, buf = bufnr, desc = 'Format line' })

	vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, {
		noremap = true,
		silent = true,
		buf = bufnr,
		desc = 'Go to implementation',
	})

	vim.keymap.set(
		'n',
		'<leader>rn',
		vim.lsp.buf.rename,
		{ noremap = true, silent = true, buf = bufnr, desc = 'Rename' }
	)

	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
		noremap = true,
		silent = true,
		buf = bufnr,
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
		buf = bufnr,
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
		buf = bufnr,
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
		buf = bufnr,
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
		buf = bufnr,
		desc = 'Workspace symbols',
	})
end

require('lazydev').setup()
local masonLspOk, masonLsp = pcall(require, 'mason-lspconfig')

if not (masonLspOk) then
	return
end

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(event)
		set_keymaps(event.buf)
	end
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
		},
	},
})

-- Python: the project's .venv decides who checks types
--   .venv/bin/ty    ty is the whole language server
--   .venv/bin/mypy  pyright for language features, mypy (via none-ls) for types
--   otherwise       pyright does both
local function python_root(bufnr)
	-- .venv first, so a uv workspace member resolves to the workspace root
	return vim.fs.root(bufnr, {
		'.venv',
		{ 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
	})
end

local function venv_bin(root, name)
	local path = root and root .. '/.venv/bin/' .. name
	return path and vim.fn.executable(path) == 1 and path or nil
end

vim.lsp.config('ty', {
	root_dir = function(bufnr, on_dir)
		local root = python_root(bufnr)
		if venv_bin(root, 'ty') then
			on_dir(root)
		end
	end,
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start(
			{ venv_bin(config.root_dir, 'ty'), 'server' },
			dispatchers,
			{ cwd = config.root_dir }
		)
	end,
})

vim.lsp.config('pyright', {
	settings = { python = { analysis = {} } },
	root_dir = function(bufnr, on_dir)
		local root = python_root(bufnr)
		if not venv_bin(root, 'ty') then
			on_dir(root)
		end
	end,
	before_init = function(_, config)
		local uses_mypy = venv_bin(config.root_dir, 'mypy') ~= nil
		config.settings.python.analysis.typeCheckingMode = uses_mypy and 'off' or 'standard'
		-- Resolve imports against the project's own venv rather than whatever python is on PATH
		config.settings.python.pythonPath = venv_bin(config.root_dir, 'python')
	end,
})
vim.lsp.enable({ 'ty', 'pyright' })

vim.lsp.config('gdscript', {
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
vim.lsp.enable('gdscript')

masonLsp.setup({
	ensure_installed = {
		'bashls',
		'clangd',
		'cssls',
		'html',
		'lua_ls',
		'pyright',
		'tsc',
		'vimls',
	},
})

vim.diagnostic.config({
	float = { border = 'rounded' },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '!',
			[vim.diagnostic.severity.WARN] = '?',
			[vim.diagnostic.severity.INFO] = 'i',
			[vim.diagnostic.severity.HINT] = '~',
		},
	},
})
