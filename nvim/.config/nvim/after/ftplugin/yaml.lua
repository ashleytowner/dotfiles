local function yaml_value(parameter)
	local result = vim.system({ 'yq', parameter, vim.api.nvim_buf_get_name(0) }, {
		text = true,
	}):wait()

	if result.code ~= 0 then
		vim.notify(result.stderr, vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_echo({ { result.stdout } }, true, {})
end

vim.api.nvim_buf_create_user_command(0, 'YamlValue', function(input)
	yaml_value(input.args)
end, { nargs = 1 })
