vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

local ok, vscode = pcall(require, "vscode")
if not ok then
	return
end

local function action(name)
	return function()
		vscode.action(name)
	end
end

vim.keymap.set("n", "<leader>ff", action("workbench.action.quickOpen"), { desc = "VS Code: quick open" })
vim.keymap.set("n", "<leader>fg", action("workbench.action.findInFiles"), { desc = "VS Code: find in files" })
vim.keymap.set("n", "<leader>e", action("workbench.view.explorer"), { desc = "VS Code: explorer" })
vim.keymap.set("n", "<M-h>", action("workbench.action.navigateLeft"), { desc = "VS Code: focus left" })
vim.keymap.set("n", "<M-j>", action("workbench.action.navigateDown"), { desc = "VS Code: focus down" })
vim.keymap.set("n", "<M-k>", action("workbench.action.navigateUp"), { desc = "VS Code: focus up" })
vim.keymap.set("n", "<M-l>", action("workbench.action.focusAuxiliaryBar"), { desc = "VS Code: focus right sidebar" })
vim.keymap.set("n", "<leader>ca", action("editor.action.quickFix"), { desc = "VS Code: code actions" })
vim.keymap.set("n", "gd", action("editor.action.revealDefinition"), { desc = "VS Code: go to definition" })
vim.keymap.set("n", "gr", action("editor.action.goToReferences"), { desc = "VS Code: references" })
