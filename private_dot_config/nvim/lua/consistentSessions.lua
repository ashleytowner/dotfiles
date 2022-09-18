local consistent_sessions_group = vim.api.nvim_create_augroup("ConsistentSessions", {clear = true})
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = consistent_sessions_group,
  command = "mks! $XDG_DATA_HOME/nvim/sessions/Last.vim"
})
