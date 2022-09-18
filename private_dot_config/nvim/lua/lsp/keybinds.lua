local P = {}

function P.set_keybinds()
  vim.keymap.set(
    'n',
    '<C-]>',
    '<cmd>Telescope lsp_definitions<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<C-k>',
    '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'i',
    '<C-k>',
    '<cmd>lua vim.lsp.buf.signature_help()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<leader>.',
    '<cmd>lua vim.lsp.buf.code_action()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    'gy',
    '<cmd>lua vim.lsp.buf.type_definition()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<leader>e',
    function ()
      local formatFunction = function(d) return '['..d.source..'] ' end
      vim.diagnostic.open_float(nil, { prefix = formatFunction })
    end,
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<leader>=',
    '<cmd>lua vim.lsp.buf.formatting()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<leader>gi',
    '<cmd>lua vim.lsp.buf.implementation()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<leader>q',
    '<cmd>lua vim.diagnostic.setloclist({open = false})<CR><cmd>Telescope loclist<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '<leader>rn',
    '<cmd>lua vim.lsp.buf.rename()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '==',
    'V:<C-u>lua vim.lsp.buf.range_formatting()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    'K',
    '<cmd>lua vim.lsp.buf.hover()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    '[d',
    '<cmd>lua vim.diagnostic.goto_prev()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    ']d',
    '<cmd>lua vim.diagnostic.goto_next()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    'gD',
    '<cmd>lua vim.lsp.buf.declaration()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'n',
    'gr',
    '<cmd>Telescope lsp_references<CR>',
    { noremap = true, silent = true, buffer = true }
  )
  vim.keymap.set(
    'v',
    '=',
    '<cmd>lua vim.lsp.buf.range_formatting()<CR>',
    { noremap = true, silent = true, buffer = true }
  )
end

return P
