-- Text manipulation
vim.keymap.set(
	'n',
	'J',
	'mzJ`z',
	{ noremap = true, desc = 'Join lines without messing up cursor position' }
)
vim.keymap.set(
	'n',
	'N',
	'Nzz',
	{ noremap = true, desc = 'Go to previous search result and center it' }
)
vim.keymap.set(
	'n',
	'n',
	'nzz',
	{ noremap = true, desc = 'Go to next search result and center it' }
)
vim.keymap.set(
	'v',
	'J',
	":m '>+1<CR>gv=gv",
	{ noremap = true, desc = 'Move selected text down 1 line' }
)
vim.keymap.set(
	'v',
	'K',
	":m '<-2<CR>gv=gv",
	{ noremap = true, desc = 'Move selected text up 1 line' }
)

-- Clipboard
vim.keymap.set(
	'',
	'<leader>P',
	'"+P',
	{ noremap = true, desc = 'Paste from system clipboard' }
)
vim.keymap.set(
	'',
	'<leader>Y',
	'"+y$',
	{ noremap = true, desc = 'Yank to system clipboard' }
)
vim.keymap.set(
	'',
	'<leader>p',
	'"+p',
	{ noremap = true, desc = 'Paste from system clipboard' }
)
vim.keymap.set(
	'',
	'<leader>y',
	'"+y',
	{ noremap = true, desc = 'Yank to system clipboard' }
)

-- File Navigation
vim.keymap.set('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix item' })
vim.keymap.set(
	'n',
	'<C-PageDown>',
	':bnext<CR>',
	{ noremap = true, desc = 'Next buffer' }
)
vim.keymap.set(
	'n',
	'<C-PageUp>',
	':bprev<CR>',
	{ noremap = true, desc = 'Previous buffer' }
)
vim.keymap.set('n', 'gw', '<C-w>w', { noremap = true, desc = 'Next window' })
vim.keymap.set(
	'n',
	'gW',
	'<C-w>W',
	{ noremap = true, desc = 'Previous window' }
)
vim.keymap.set(
	'n',
	'<C-u>',
	'<C-u>zz',
	{ noremap = true, desc = 'Scroll up and center' }
)
vim.keymap.set(
	'n',
	'<C-d>',
	'<C-d>zz',
	{ noremap = true, desc = 'Scroll down and center' }
)
vim.keymap.set(
	'n',
	'<C-6>',
	'<C-^>',
	{ noremap = true, desc = 'Switch to previous buffer' }
)

-- Terminal
vim.keymap.set(
	't',
	'<C-\\>',
	'<C-\\><C-n><C-w>w',
	{ noremap = true, desc = 'Next window out of terminal' }
)
vim.keymap.set(
	't',
	'<C-n>',
	'<C-\\><C-n>',
	{ noremap = true, desc = 'Exit terminal mode' }
)

-- Diff commands
if vim.wo.diff then
	vim.keymap.set(
		{'n', 'v'},
		'<leader>1',
		':diffget 1<CR>',
		{ noremap = true, desc = 'Get diff from left' }
	)
	vim.keymap.set(
		{'n', 'v'},
		'<leader>2',
		':diffget 2<CR>',
		{ noremap = true, desc = 'Get diff from middle' }
	)
	vim.keymap.set(
		{'n', 'v'},
		'<leader>3',
		':diffget 3<CR>',
		{ noremap = true, desc = 'Get diff from right' }
	)
end

vim.keymap.set('', '<leader>/', function()
	local bufs = require('util').get_buffers()
	local terminal_buffer = -1

	for _, buf in ipairs(bufs) do
		if vim.api.nvim_buf_get_option(buf.number, 'buftype') == 'terminal' then
			terminal_buffer = buf.number
			break
		end
	end

	if terminal_buffer == -1 then
		vim.cmd('sbuffer +term')
	else
		local wins = require('util').get_windows()
		local was_open = false

		for _, win in ipairs(wins) do
			if vim.api.nvim_win_get_buf(win) == terminal_buffer then
				vim.api.nvim_win_close(win, true)
				was_open = true
				break
			end
		end

		if not was_open then
			vim.cmd('sbuffer ' .. terminal_buffer)
		end
	end
end, { noremap = true, desc = 'Open terminal' })

-- Files

-- vim.keymap.set('n', '-', '<CMD>Ex<CR>', { desc = 'File explorer' })
