local dapOk, dap = pcall(require, 'dap')

local mason_path = vim.fn.stdpath('data')..'/mason/bin'

if not dapOk then
  return
end
vim.keymap.set('n', '<F8>', "<CMD>lua require('dap').continue()<CR>")
vim.keymap.set('n', '<leader>b', "<CMD>lua require('dap').toggle_breakpoint()<CR>")

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { mason_path..'/node-debug2-adapter' }
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal'
  },
  {
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require('dap.utils').pick_process
  }
}
