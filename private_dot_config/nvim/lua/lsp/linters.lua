local P = {}

P.prettier = {
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
  -- lintSource = "prettier",
  env = {
    string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.config/nvim/utils/linter-config/.prettierrc.json')),
  },
}

function P.eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") ~= 0 then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

P.eslint = {
  lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {
    "%f(%l,%c): %tarning %m",
    "%f(%l,%c): %trror %m"
  },
  lintIgnoreExitCode = true,
  lintSource = "eslint",
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

return P
