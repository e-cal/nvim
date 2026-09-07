-- VSCode / Cursor entry point.
-- Loaded by vscode-neovim when `vscode-neovim.neovimInitVimPaths` points here,
-- so this file REPLACES init.lua inside the editor. Goal: enable the vanilla
-- features from the core nvim config (settings, keybinds, filetype
-- autocommands, vanilla user commands) without pulling in plugins, lsp,
-- or plugin-dependent autocommands / user commands. All importing /
-- monkeypatching is kept in this file so the core config files stay untouched.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
-- Vanilla settings & keybinds (core config, no plugin deps)
--------------------------------------------------------------------------------
require("settings")
require("keybinds")

--------------------------------------------------------------------------------
-- Utils (no plugins; provides Utils.make_command for the vanilla commands below)
--------------------------------------------------------------------------------
require("utils")

--------------------------------------------------------------------------------
-- Vanilla user commands (subset of lua/functions.lua)
-- Skipped (plugin-dependent): Format/cabbrev, PreviewDoc (MarkdownPreview /
-- Vimtex), PS (PackerSync), TelescopeSearchDotfiles/Chats/Dir, Reload.
--------------------------------------------------------------------------------
NewFile = function()
	local name = vim.fn.input("File name: ", "", "file")
	vim.api.nvim_command("e " .. name)
end
Utils.make_command("NewFile")

OpenLast = function()
	vim.cmd("e " .. vim.v.oldfiles[1])
end
Utils.make_command("OpenLast")

BufDeleteAll = function()
	vim.cmd([[w | let pos = getpos('.') | silent %bd | e# | bd# | call setpos('.', pos)]])
end
Utils.make_command("BufDeleteAll")
vim.cmd("cabbrev bda BufDeleteAll")

local session_dir = vim.fn.stdpath("data") .. "/sessions/"

StoreSession = function()
	local dir = string.gsub(vim.fn.getcwd(), "/", "_")
	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end
	vim.cmd("mksession! " .. session_dir .. dir)
end
Utils.make_command("StoreSession")

RestoreSession = function()
	local dir = string.gsub(vim.fn.getcwd(), "/", "_")
	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end
	local fp = session_dir .. dir
	local f = io.open(fp, "r")
	if f ~= nil then
		vim.cmd("source " .. fp)
	end
end
Utils.make_command("RestoreSession")

QuickfixToggle = function()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.quickfix == 1 then
			vim.cmd("cclose")
		else
			vim.cmd("copen")
		end
	end
end
Utils.make_command("QuickfixToggle")

TrimWhitespace = function()
	local patterns = {
		[[%s/\s\+$//e]],
		[[%s/\($\n\s*\)\+\%$//]],
		[[%s/\%^\n\+//]],
		[[%s/\(\n\n\)\n\+/\1/]],
	}
	local save = vim.fn.winsaveview()
	for _, v in pairs(patterns) do
		vim.api.nvim_exec(string.format("keepjumps keeppatterns silent! %s", v), false)
	end
	vim.fn.winrestview(save)
end
Utils.make_command("TrimWhitespace")

CleanText = function()
	vim.cmd("%s/–\\|•\\|▪/-/ge")
	vim.cmd("%s/■/-/ge")
	vim.cmd("%s/❑/↳ /ge")
	vim.cmd("%s/’\\|‘/'/ge")
	vim.cmd('%s/“\\|”/"/ge')
end
Utils.make_command("CleanText")

--------------------------------------------------------------------------------
-- Vanilla filetype autocommands (subset of lua/auto.lua)
-- Skipped (need lsp): the global CursorMoved `vim.lsp.buf.clear_references`.
-- Skipped (no value inside the editor): VimLeave -> StoreSession.
--------------------------------------------------------------------------------
vim.filetype.add({
	extension = {
		mdc = "markdown",
	},
})

augroup("vscode_filteroptions", { clear = true })
autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = "vscode_filteroptions",
	callback = function()
		local excluded_filetypes = { markdown = true, json = true }
		if not excluded_filetypes[vim.bo.filetype] then
			vim.bo.formatoptions = "jql"
		end
	end,
})

augroup("vscode_markdown", { clear = true })
autocmd({ "BufEnter" }, {
	group = "vscode_markdown",
	pattern = { "*.md", "*.mdc" },
	callback = function()
		vim.cmd('syntax match markdownIgnore "\\v\\w_\\w"')
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.cmd("set spell")
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.opt_local.formatoptions:remove("t")
		vim.opt_local.textwidth = 0
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
	end,
})

augroup("vscode_json", { clear = true })
autocmd({ "BufEnter" }, {
	group = "vscode_json",
	pattern = "*.json*",
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
	end,
})

augroup("vscode_python", { clear = true })
autocmd({ "BufEnter" }, {
	group = "vscode_python",
	pattern = "*.py",
	callback = function()
		vim.cmd("setlocal indentkeys-=<:> indentkeys-=:")
	end,
})

augroup("vscode_conf", { clear = true })
autocmd({ "BufEnter" }, { group = "vscode_conf", pattern = "*.conf", command = "setlocal ft=conf" })
autocmd({ "BufEnter" }, { group = "vscode_conf", pattern = "*.yuck", command = "setlocal ts=2 sw=2 sts=2" })

augroup("vscode_c", { clear = true })
autocmd({ "BufEnter" }, { group = "vscode_c", pattern = "Makefile", command = "setlocal noexpandtab" })

augroup("vscode_web", { clear = true })
autocmd({ "BufEnter" }, {
	group = "vscode_web",
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.html", "*.css", "*.scss", "*.json" },
	command = "setlocal ts=2 sw=2 sts=2",
})

augroup("vscode_nix", { clear = true })
autocmd({ "BufEnter" }, { group = "vscode_nix", pattern = { "*.nix" }, command = "setlocal ts=2 sw=2 sts=2" })

augroup("vscode_latex", { clear = true })
autocmd({ "BufEnter" }, {
	group = "vscode_latex",
	pattern = "*.tex",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		vim.keymap.set("n", "^", "g^", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
		vim.keymap.set("v", "^", "g^", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
	end,
})

--------------------------------------------------------------------------------
-- VSCode-specific keymaps (delegate to vscode actions)
--------------------------------------------------------------------------------
local ok, vscode = pcall(require, "vscode")
if not ok then
	return
end

local function action(name)
	return function()
		vscode.action(name)
	end
end

vim.keymap.set("n", "<leader>o", action("workbench.action.quickOpen"), { desc = "VS Code: quick open" })
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
