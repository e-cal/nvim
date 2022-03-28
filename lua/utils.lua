local api = vim.api

Utils = {}

Utils.make_command = function(command, func)
	func = func or command
	local str = string.format("command! %s lua %s()", command, func)
	api.nvim_command(str)
end

Utils.make_augroups = function(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command("augroup " .. group_name)
		api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			api.nvim_command(command)
		end
		api.nvim_command("augroup END")
	end
end
