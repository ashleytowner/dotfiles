require('nvim-autopairs').setup({})

-- set up auto pairs on cmp completions
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_err, cmp = pcall(require, 'cmp')
if not cmp_err then
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' }}))

  cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
end
