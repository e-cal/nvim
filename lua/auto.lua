local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
--                                   Global                                   --
--------------------------------------------------------------------------------
augroup("global", { clear = true })
autocmd({ "VimLeave" }, { group = "global", command = "StoreSession" })
autocmd({ "BufEnter" }, { group = "global", command = "LspStart" })
-- autocmd({ "VimEnter" }, {
-- 	group = "global",
-- 	callback = function()
-- 		local oc = require("opencode")
-- 		require("opencode.cli.server")
-- 			.get(false)
-- 			:next(function(server)
-- 				vim.notify(
-- 					"Connected to opencode on port " .. server.port,
-- 					vim.log.levels.INFO,
-- 					{ title = "opencode" }
-- 				)
-- 			end)
-- 			:catch(function(err)
-- 				vim.notify("Starting opencode...", vim.log.levels.INFO, { title = "opencode" })
-- 				oc.start()
-- 			end)
-- 	end,
-- })
autocmd({ "CursorMoved" }, {
	group = "global",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = "global",
	callback = function()
		local excluded_filetypes = { markdown = true, json = true }
		if not excluded_filetypes[vim.bo.filetype] then
			vim.bo.formatoptions = "jql"
		end
	end,
})

--------------------------------------------------------------------------------
--                                 Filetypes                                  --
--------------------------------------------------------------------------------
augroup("markdown", { clear = true })
autocmd({ "BufEnter" }, {
	group = "markdown",
	pattern = "*.md",
	callback = function()
		vim.cmd('syntax match markdownIgnore "\\v\\w_\\w"')
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.cmd("set spell")
		-- Enable wrapping and linebreak
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		-- Disable auto newline at textwidth
		vim.opt_local.formatoptions:remove("t")
		-- Map movement keys to their screen-line equivalents
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		vim.keymap.set("n", "^", "g^", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		-- Same for visual mode
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
		vim.keymap.set("v", "^", "g^", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
	end,
})

augroup("json", { clear = true })
autocmd({ "BufEnter" }, {
	group = "json",
	pattern = "*.json*",
	callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
    end,
})

augroup("python", { clear = true })
autocmd({ "BufEnter" }, {
	group = "python",
	pattern = "*.py",
	callback = function()
		vim.cmd("setlocal indentkeys-=<:> indentkeys-=:")
	end,
})

augroup("conf", { clear = true })
autocmd({ "BufEnter" }, {
	group = "conf",
	pattern = "*.conf",
	command = "setlocal ft=conf",
})
autocmd({ "BufEnter" }, {
	group = "conf",
	pattern = "*.yuck",
	command = "setlocal ts=2 sw=2 sts=2",
})

augroup("c", { clear = true })
autocmd({ "BufEnter" }, {
	group = "c",
	pattern = "Makefile",
	command = "setlocal noexpandtab",
})

augroup("web", { clear = true })
autocmd({ "BufEnter" }, {
	group = "web",
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.html", "*.css", "*.scss", "*.json" },
	command = "setlocal ts=2 sw=2 sts=2",
})

augroup("nix", { clear = true })
autocmd({ "BufEnter" }, {
	group = "nix",
	pattern = { "*.nix" },
	command = "setlocal ts=2 sw=2 sts=2",
})


augroup("latex", { clear = true })
autocmd({ "BufEnter" }, {
	group = "latex",
	pattern = "*.tex",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		-- Map movement keys to their screen-line equivalents
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		vim.keymap.set("n", "^", "g^", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		-- Same for visual mode
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
		vim.keymap.set("v", "^", "g^", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
	end,
})
