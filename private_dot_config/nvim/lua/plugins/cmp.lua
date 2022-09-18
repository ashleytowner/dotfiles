local lspkind = require('lspkind')

lspkind.init()

local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'calc' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = false,
      menu = {
        buffer = '[buf]',
        nvim_lsp = '[LSP]',
        path = '[path]',
        calc = '[calc]',
        vsnip = '[vsnip]'
      }
    })
  }
}
