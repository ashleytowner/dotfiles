-- Works out which type checker a Python project uses, and where its tools live.
--
-- The checker is chosen per project, first match wins:
--   ty      .venv/bin/ty, ty.toml, or [tool.ty] in pyproject.toml
--   mypy    .venv/bin/mypy, mypy.ini, .mypy.ini, [tool.mypy] in pyproject.toml, or [mypy] in setup.cfg
--   pyright everything else
--
-- Tools are run from the project's .venv (the version uv installed for it) when present,
-- falling back to whatever is on PATH (mason or `uv tool install`).

local M = {}

local root_markers = {
	'.venv',
	'pyproject.toml',
	'setup.py',
	'setup.cfg',
	'requirements.txt',
	'.git',
}

---Root of the Python project containing a buffer. A uv workspace's .venv sits
---beside its uv.lock, so that wins over a member package's own pyproject.toml.
---@param bufnr integer
---@return string|nil
function M.root(bufnr)
	return vim.fs.root(bufnr, { 'uv.lock' }) or vim.fs.root(bufnr, root_markers)
end

---Path to a tool in the project's .venv, if uv installed it there
---@param root string|nil
---@param name string
---@return string|nil
function M.local_bin(root, name)
	if not root then
		return nil
	end
	local path = root .. '/.venv/bin/' .. name
	if vim.fn.executable(path) == 1 then
		return path
	end
	return nil
end

---The project's copy of a tool, or the global one
---@param root string|nil
---@param name string
---@return string
function M.bin(root, name)
	return M.local_bin(root, name) or name
end

---@param path string
---@param pattern string
---@return boolean
local function file_matches(path, pattern)
	local f = io.open(path, 'r')
	if not f then
		return false
	end
	local content = f:read('*a')
	f:close()
	return content:find(pattern) ~= nil
end

---@param root string
---@param name string
---@return boolean
local function has_file(root, name)
	return vim.uv.fs_stat(root .. '/' .. name) ~= nil
end

---The type checker the project uses
---@param root string|nil
---@return 'ty'|'mypy'|'pyright'
function M.checker(root)
	if not root then
		return 'pyright'
	end
	local pyproject = root .. '/pyproject.toml'

	if
		M.local_bin(root, 'ty')
		or has_file(root, 'ty.toml')
		or file_matches(pyproject, '%[tool%.ty[%]%.]')
	then
		return 'ty'
	end

	if
		M.local_bin(root, 'mypy')
		or has_file(root, 'mypy.ini')
		or has_file(root, '.mypy.ini')
		or file_matches(pyproject, '%[tool%.mypy[%]%.]')
		or file_matches(root .. '/setup.cfg', '%[mypy[%]-]')
	then
		return 'mypy'
	end

	return 'pyright'
end

return M
