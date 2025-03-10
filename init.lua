require("settings")
require("keymap")

if not vim.g.vscode then
	require("utils")
	require("plugins")
	require("functions")
	require("auto")
	require("lsp")

    -- include all files in lua/custom/
	local dir = vim.fn.stdpath("config") .. "/lua/custom"
	if vim.fn.isdirectory(dir) == 1 then
		local files = vim.fn.glob(dir .. "/*.lua", false, true)
		for _, f in ipairs(files) do
			local module = vim.fn.fnamemodify(f, ":t:r")
			require("custom." .. module)
		end
	end
end
