require("settings")
require("keymap")

if not vim.g.vscode then
	require("utils")
	require("plugins")
	require("functions")
	require("auto")
	require("colors")
	require("lsp")

	require("plugins.packer_compiled")
	for _, file in ipairs(vim.fn.readdir(os.getenv("HOME") .. "/.config/nvim/lua/plugins")) do
		if string.match(file, ".lua") and file ~= "packer_compiled.lua" then
			require("plugins." .. string.gsub(file, ".lua", ""))
		end
	end
end
