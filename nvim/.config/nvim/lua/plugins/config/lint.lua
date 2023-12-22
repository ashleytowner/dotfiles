local lint = require('lint')

lint.linters_by_ft = {
	typescript = { 'eslint_d' },
	typescriptreact = { 'eslint_d' },
	javascript = { 'eslint_d' },
	javascriptreact = { 'eslint_d' },
	-- css = { 'stylelint' },
	-- scss = { 'stylelint' },
}

local lint_group = vim.api.nvim_create_augroup('Linters', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave' }, {
	callback = function()
		lint.try_lint()
	end,
	group = lint_group,
})
