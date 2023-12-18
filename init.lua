require("settings")
require("keymap")

if not vim.g.vscode then
	require("utils")
	require("plugins")
	require("functions")
	require("auto")
	require("lsp")
end
