local u = require('util')

local function is_window_focused()
  return vim.g.statusline_winid == vim.fn.win_getid(vim.fn.winnr())
end

local function color_when_focused(color)
  return is_window_focused() and '%#' .. color .. '#' or '%*'
end

local function buffer_icon()
  local buffernum = vim.fn.winbufnr(vim.g.statusline_winid)
  local iconData = u.get_file_icon(vim.fn.expand('#' .. buffernum .. ':t'))

  if not iconData.icon then
    return ''
  end

  local bg = u.get_color('StatusLine', 'bg')
  u.create_highlight_group('User1', iconData.color, bg)
  return color_when_focused('User1') .. iconData.icon .. '%*'
end

local function buffer_label()
  local fg = u.get_color('Constant', 'fg')
  local bg = u.get_color('StatusLine', 'bg')
  u.create_highlight_group('User2', fg, bg)
  return color_when_focused('User2') .. ' ﬘%* %n %q '
end

-- Asynchronously set git status variables
local asyncOk, async = pcall(require, 'plenary.async')

local get_git_status = asyncOk and
async.void(function()
  vim.g.git_status = u.system('git status -sb 2> /dev/null')
  vim.g.git_stashes = u.trim(u.system('git stash list 2> /dev/null | wc -l'))
  vim.g.git_branch = u.trim(u.system('git branch --show-current 2> /dev/null'))
  vim.g.git_commit = u.trim(u.system('git rev-parse --short HEAD 2> /dev/null'))
end)
or
(function()
  vim.g.git_status = ''
  vim.g.git_stashes = ''
  vim.g.git_branch = ''
  vim.g.git_commit = ''
end)

-- Automatically regenerate git status on certain events
local git_status_group = vim.api.nvim_create_augroup("GitStatus", { clear = true })
vim.api.nvim_create_autocmd(
  {"BufEnter", "FocusGained", "BufWritePost"},
  {
    group = git_status_group,
    callback = function()
      get_git_status()
    end
  }
)


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

  local gs_behind = behind ~= nil and ' '
    .. color_when_focused('User3') .. '⇣%*' .. behind or ''

  local gs_ahead = ahead ~= nil and ' '
    .. color_when_focused('User3') .. '⇡%*' .. ahead or ''

  local gs_unstaged = unstaged ~= 0 and ' '
    .. color_when_focused('User3') .. '!%*' .. unstaged or ''

  local gs_untracked = untracked ~= 0 and ' '
    .. color_when_focused('User3') .. '?%*' .. untracked or ''

  local gs_staged = staged ~= 0 and ' '
    .. color_when_focused('User3') .. '+%*' .. staged or ''

  local gs_stashes = vim.g.git_stashes ~= '0' and ' '
    .. color_when_focused('User3') .. '*%*' .. vim.g.git_stashes or ''

  local gs = gs_behind
    .. gs_ahead
    .. gs_stashes
    .. gs_staged
    .. gs_unstaged
    .. gs_untracked

  return u.trim(gs)
end

local function git_branch()
  local fg = u.get_color('Label', 'fg')
  local bg = u.get_color('StatusLine', 'bg')
  u.create_highlight_group('User3', fg, bg)

  if (vim.g.git_branch == '' and vim.g.git_commit == '') then
    return ''
  end
  return u.ternary(vim.g.git_branch ~= '', '', 'ﰖ') .. '%* '
    .. u.ternary(vim.g.git_branch ~= '', vim.g.git_branch, vim.g.git_commit)
end

local function git_info()
  return ' ' .. color_when_focused('User3') .. git_branch() .. ' '
    .. git_status() .. '%*'
end

local function buffer_info()
  return '%*' .. buffer_label() .. buffer_icon() .. ' %t %m%r'
end

local function position_info()
  return '%= %<%-6.(%l:%c%) %-4.(%P%)'
end

function StatusLine()
  local bufnum = vim.fn.winbufnr(vim.g.statusline_winid);
  local buftype = vim.api.nvim_buf_get_option(bufnum, 'buftype')

  if buftype == 'nofile' then
    return ' %t%=%(%P%)'
  end

  return buffer_info() .. git_info() .. position_info()
end
