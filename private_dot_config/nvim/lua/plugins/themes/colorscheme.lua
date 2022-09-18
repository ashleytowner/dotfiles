local set_color_by_time = false

local schemes = {
  dark = 'tokyonight-night',
  light = 'tokyonight-day'
}

-- Set colorscheme based on time
local set_color = require('plenary.async').void(function()
  local hour = tonumber(Util.system('date +"%H"'))
  if hour > 7 and hour < 18 then
    vim.cmd('colorscheme '..schemes.light)
  else
    vim.cmd('colorscheme '..schemes.dark)
  end
end)

if set_color_by_time then
  local color_group = vim.api.nvim_create_augroup("Color", { clear = true });
  vim.api.nvim_create_autocmd("BufEnter", {
    group = color_group,
    callback = set_color
  })
  set_color()
else
  vim.cmd('colorscheme '..schemes.dark)
end
