local u = require('util')

---Check if the statusline's window is focused
local function is_window_focused()
	return vim.g.statusline_winid == vim.fn.win_getid(vim.fn.winnr())
end

---Apply a colour to text, only if the statusline's window is focused
---@param color string
local function color_when_focused(color)
	return is_window_focused() and '%#' .. color .. '#' or '%*'
end

---Get the file icon for the current buffer in the statusline's window
---@return string
local function buffer_icon()
	local buffernum = vim.fn.winbufnr(vim.g.statusline_winid)
	local iconData = u.get_file_icon(vim.fn.expand('#' .. buffernum .. ':t'))

	if not iconData.icon then
		return ''
	end

	local bg = u.get_color('StatusLine', 'bg')
	u.create_highlight_group('FTStatusLine', iconData.color, bg)
	return color_when_focused('FTStatusLine') .. iconData.icon .. '%*'
end

---Get the formatted buffer name for the active buffer in the statusline's window
local function buffer_label()
	local fg = u.get_color('Constant', 'fg')
	local bg = u.get_color('StatusLine', 'bg')
	u.create_highlight_group('BufferIconStatusLine', fg, bg)
	return color_when_focused('BufferIconStatusLine') .. ' ﬘%* %n %q '
end

-- Asynchronously set git status variables
local asyncOk, async = pcall(require, 'plenary.async')

vim.g.git_status = ''
vim.g.git_stashes = ''
vim.g.git_branch = ''
vim.g.git_commit = ''

---Get the git status asynchronously, and set the results to vim.g.git_*
---@return nil
local get_git_status = asyncOk
		and async.void(function()
			async.util.sleep(10)
			vim.g.git_status = u.system('git status -sb 2> /dev/null')
			vim.g.git_stashes =
				u.trim(u.system('git stash list 2> /dev/null | wc -l') or '')
			vim.g.git_branch =
				u.trim(u.system('git branch --show-current 2> /dev/null') or '')
			vim.g.git_commit =
				u.trim(u.system('git rev-parse --short HEAD 2> /dev/null') or '')
		end)
	or function()
		vim.g.git_status = ''
		vim.g.git_stashes = ''
		vim.g.git_branch = ''
		vim.g.git_commit = ''
	end

-- Automatically regenerate git status on certain events
local git_status_group =
	vim.api.nvim_create_augroup('GitStatus', { clear = true })

vim.api.nvim_create_autocmd(
	{ 'BufEnter', 'FocusGained', 'BufWritePost', 'CmdlineLeave' },
	{
		group = git_status_group,
		callback = function()
			get_git_status()
		end,
	}
)

---Get the formatted git status info for the current repo, 
---from the vim.g.git_* variables
---@return string
local function git_status()
	local cmd_output = vim.g.git_status

	if not cmd_output then
		return ''
	end

	if cmd_output == '' then
		return ''
	end

	local ahead = string.match(cmd_output, 'ahead (%d+)')

	local behind = string.match(cmd_output, 'behind (%d+)')

	local staged = 0
	for _ in string.gmatch(cmd_output, '\nM.') do
		staged = staged + 1
	end
	for _ in string.gmatch(cmd_output, '\nA.') do
		staged = staged + 1
	end
	for _ in string.gmatch(cmd_output, '\nD.') do
		staged = staged + 1
	end

	local unstaged = 0
	for _ in string.gmatch(cmd_output, '\n.M') do
		unstaged = unstaged + 1
	end
	for _ in string.gmatch(cmd_output, '\n.D') do
		unstaged = unstaged + 1
	end

	local untracked = 0
	for _ in string.gmatch(cmd_output, '\n%?%?') do
		untracked = untracked + 1
	end

	local gs_behind = behind ~= nil
			and ' ' .. color_when_focused('GitSignsStatusLine') .. '⇣%*' .. behind
		or ''

	local gs_ahead = ahead ~= nil
			and ' ' .. color_when_focused('GitSignsStatusLine') .. '⇡%*' .. ahead
		or ''

	local gs_unstaged = unstaged ~= 0
			and ' ' .. color_when_focused('GitSignsStatusLine') .. '!%*' .. unstaged
		or ''

	local gs_untracked = untracked ~= 0
			and ' ' .. color_when_focused('GitSignsStatusLine') .. '?%*' .. untracked
		or ''

	local gs_staged = staged ~= 0
			and ' ' .. color_when_focused('GitSignsStatusLine') .. '+%*' .. staged
		or ''

	local gs_stashes = vim.g.git_stashes ~= '0'
			and ' ' .. color_when_focused('GitSignsStatusLine') .. '*%*' .. vim.g.git_stashes
		or ''

	local gs = gs_behind
		.. gs_ahead
		.. gs_stashes
		.. gs_staged
		.. gs_unstaged
		.. gs_untracked

	return u.trim(gs)
end

---Get the formatted git branch info for the current repo
---@return string
local function git_branch()
	local fg = u.get_color('@keyword', 'fg')
	local bg = u.get_color('StatusLine', 'bg')
	u.create_highlight_group('GitSignsStatusLine', fg, bg)

	if vim.g.git_branch == '' and vim.g.git_commit == '' then
		return ''
	end
	return u.ternary(vim.g.git_branch ~= '', '', 'ﰖ')
		.. '%* '
		.. u.ternary(
			vim.g.git_branch ~= '',
			vim.g.git_branch
				.. ' %#FiletypeStatusLine#['
				.. vim.g.git_commit
				.. ']%*',
			vim.g.git_commit
		)
end

---Get the formatted git status and branch info for the current repo
---@return string
local function git_info()
	return color_when_focused('GitSignsStatusLine')
		.. git_branch()
		.. ' '
		.. git_status()
		.. '%*'
end

---Get the formatted file type info for the current buffer
local function filetype_info()
	local bg = u.get_color('StatusLine', 'bg')
	local fg = u.get_color('Comment', 'fg')
	u.create_highlight_group('FiletypeStatusLine', fg, bg)
	return color_when_focused('FiletypeStatusLine') .. '%y%*'
end

---Get the formatted buffer info for the current buffer
local function buffer_info()
	return '%*'
		.. buffer_label()
		.. buffer_icon()
		.. ' %t '
		.. filetype_info()
		.. ' %m%r'
end

---Get the formatted position info in the current buffer
local function position_info()
	return color_when_focused('FiletypeStatusLine')
		.. '%30{nvim_treesitter#statusline(30)} '
		.. color_when_focused('BufferIconStatusLine')
		.. ' %*%<%-6.(%l:%c%) %-4.(%P%)'
end

---Get the formatted codeium info
local function codeium_info()
	local bg = u.get_color('StatusLine', 'bg')
	u.create_highlight_group('CodeiumLogoStatusLine', '#09b6a2', bg)
	if vim.g.ai == 'codeium' then
		return color_when_focused('CodeiumLogoStatusLine')
			.. '{…}%*%3{codeium#GetStatusString()} '
	end
	return ''
end

---Get the status line for the current window
function StatusLine()
	local bufnum = vim.fn.winbufnr(vim.g.statusline_winid)
	local buftype = vim.api.nvim_buf_get_option(bufnum, 'buftype')

	if buftype == 'nofile' then
		return ' %t%=%(%P%)'
	end

	return buffer_info()
		.. (not vim.wo.diff and git_info() or '')
		.. '%='
		.. codeium_info()
		.. position_info()
end
