local M = {}

function M.run()
  local programs = {
    'eslint_d',
    'prettierd',
  }

  local cmdString = 'MasonInstall'

  for i in ipairs(programs)
  do
    cmdString = cmdString .. ' ' .. programs[i]
  end

  vim.cmd(cmdString)

end

return M
