dofile(os.getenv("HOME") .. "/.config/nvim/settings.lua")
require("vim-settings")

if vim.g.vscode then
    -- VSCode specific
    local map = vim.keymap.set
    map("n", "n", "nzzzv")
    map("n", "N", "Nzzzv")
    map("n", "J", "mzJ`z")
    map("n", "<C-d>", "<C-d>zz")
    map("n", "<C-u>", "<C-u>zz")
    map("n", "<C-o>", "<C-o>zz")
    map("n", "<C-i>", "<C-i>zz")
    map("i", ",", ",<C-g>u")
    map("i", ".", ".<C-g>u")
    map("i", "!", "!<C-g>u")
    map("i", "?", "?<C-g>u")
    map("v", "<", "<gv")
    map("v", ">", ">gv")
    map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
    map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
    map("n", "Q", "<NOP>")
else
	require("utils")
	require("plugins")
	require("keymap")
	require("functions")
	require("auto")
	require("colors")

	-- LSP
	require("lsp")

	-- Plugins
	require("plugins.packer_compiled")
	for _, file in ipairs(vim.fn.readdir(os.getenv("HOME") .. "/.config/nvim/lua/plugins")) do
		if string.match(file, ".lua") and not string.match(file, "packer_compiled") then
			require("plugins." .. string.gsub(file, ".lua", ""))
		end
	end
end
