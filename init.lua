-- Some plugins still call vim.tbl_flatten, which warns on every startup in Nvim 0.12.
if vim.iter then
	vim.tbl_flatten = function(t)
		return vim.iter(t):flatten(math.huge):totable()
	end
end

require("config.options")
require("config.keymaps")

if not vim.g.vscode then
	require("config.utils")
	require("config.lazy")
	require("config.commands")
	require("config.autocmds")
	require("config.lsp")
	require("tools.ipython")
	require("tools.remote_sync")
	require("config.highlights")
end
