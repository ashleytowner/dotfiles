local ts_utils = require('nvim-treesitter.ts_utils')
local ts = require('util').TS

local function toggle_check()
	local list_item = ts.get_parent_node_of_type({ 'list_item' })
	if list_item == nil then
		return false
	end
	for node in list_item:iter_children() do
		if
			node:type() == 'task_list_marker_unchecked'
			or node:type() == 'task_list_marker_checked'
		then
			local current_position = vim.api.nvim_win_get_cursor(0)
			ts_utils.goto_node(node)
			if node:type() == 'task_list_marker_checked' then
				vim.cmd('norm lr ')
			else
				vim.cmd('norm lrx')
			end
			vim.api.nvim_win_set_cursor(0, current_position)
		end
	end
	return true
end

vim.keymap.set({ 'n' }, '<leader>x', function()
	if not toggle_check() then
		vim.cmd('norm ' .. vim.g.mapleader .. 'x')
	end
end, { noremap = true, buffer = true, silent = true })

local function add_header(level)
	local current_position = vim.api.nvim_win_get_cursor(0)
	print(vim.inspect(current_position))
	local hashes = ''
	for _ = level, 1, -1 do
		hashes = hashes .. '#'
	end
	vim.cmd('norm I' .. hashes .. ' ')
	vim.api.nvim_win_set_cursor(
		0,
		{ current_position[1], current_position[2] + 1 + level }
	)
end

local function get_header()
	local section = ts.get_parent_node_of_type({ 'section' })
	if section == nil then
		return nil
	end
	local header
	for child in section:iter_children() do
		if child:type() == 'atx_heading' then
			header = child
			break
		end
	end
	return header
end

local function get_list_marker()
	local item = ts.get_parent_node_of_type({ 'list_item' })
	if item == nil then
		return nil
	end
	local marker = ''
	local is_numbered = false
	for child in item:iter_children() do
		if child:type() == 'list_marker_dot' then
			is_numbered = true
		end
		if string.find(child:type(), 'list_marker') then
			marker = marker .. vim.treesitter.get_node_text(child, 0)
			if string.find(child:type(), 'task_list_marker') then
				marker = marker .. ' '
			end
		end
	end
	return marker, is_numbered
end

vim.keymap.set({ 'n' }, '<leader>o', function()
	local marker, is_numbered = get_list_marker()
	if marker == nil then
		return
	end
	vim.cmd('norm o' .. marker)
	if is_numbered then
		vim.cmd('norm 0$')
	end
	vim.cmd('startinsert!')
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'o', 'x' }, 'ah', function()
	local header = get_header()
	if header == nil then
		return
	end
	ts.select_node(header)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'o', 'x' }, 'ih', function()
	local header = get_header()
	if header == nil then
		return
	end
	local inline
	for child in header:iter_children() do
		if child:type() == 'inline' then
			inline = child
			break
		end
	end
	ts.select_node(inline)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'n' }, '<leader>h1', function()
	add_header(1)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'n' }, '<leader>h2', function()
	add_header(2)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'n' }, '<leader>h3', function()
	add_header(3)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'n' }, '<leader>h4', function()
	add_header(4)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'n' }, '<leader>h5', function()
	add_header(5)
end, { noremap = true, buffer = true, silent = true })

vim.keymap.set({ 'n' }, '<leader>h6', function()
	add_header(6)
end, { noremap = true, buffer = true, silent = true })
