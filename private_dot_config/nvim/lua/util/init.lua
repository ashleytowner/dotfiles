require('util.objects')

local M = {}

function M.spread(template)
  local result = {}
  for key, value in pairs(template) do
    result[key] = value
  end

  return function(table)
    for key, value in pairs(table) do
      result[key] = value
    end
    return result
  end
end

function M.trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function M.get_table_len(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end
  return count
end

function M.system(cmd)
  local handle = io.popen(cmd)
  if (handle == nil) then
    return nil
  end
  local result = handle:read('*a')
  handle:close()
  return result
end


function M.get_color(group, attr)
  local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
  return color or nil
end

function M.ternary(condition, aval, bval)
  if condition then
    return aval
  else
    return bval
  end
end

function M.get_file_icon(filename)
  local extension = vim.fn.fnamemodify(filename, ':e')
  local deviconsOk, devicons = pcall(require, 'nvim-web-devicons')
  if not deviconsOk then
    return {
      icon = '?',
      color = '#FFFFFF',
      highlight = ''
    }
  end
  local icon, color = devicons
    .get_icon_color(filename, extension, { default = true })
  local _, highlight = require('nvim-web-devicons').get_icon(filename, extension, { default = true })
  return {
    icon = icon,
    color = color,
    highlight = highlight
  }
end

function M.get_plugin_hash(plugin)
  return M.system('git ls-remote https://github.com/'..plugin..'.git HEAD | awk \'{ print $1 }\'')
end

function M.yank(text)
  vim.fn.setreg('"', text)
end

function M.create_highlight_group(group, fg, bg)
  if fg == nil or fg == '' or bg == nil or bg == '' then
    return
  end
  vim.cmd('hi ' .. group .. ' guifg=' .. fg .. ' guibg=' .. bg)
end

return M
