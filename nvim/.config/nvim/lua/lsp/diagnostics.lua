function diagnostics_popup()
    local formatFunction = function(d) return '['..d.source..'] ' end
    vim.diagnostic.open_float(nil, { prefix = formatFunction })
end

vim.fn.sign_define("DiagnosticSignError",
    {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",
    {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInformation",
    {text = "", texthl = "DiagnosticSignInformation"})
vim.fn.sign_define("DiagnosticSignHint",
    {text = "", texthl = "DiagnosticSignHint"})
