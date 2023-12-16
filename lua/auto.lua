local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
--                                   Global                                   --
--------------------------------------------------------------------------------
augroup("global", { clear = true })
-- format options
autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = "global",
	command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t",
})
-- yellow title on edit
autocmd({ "BufReadPost", "BufWritePost", "BufEnter", "TextChanged", "TextChangedI" }, {
	group = "global",
	command = "UpdateWinbarHighlight",
})
-- clear references on cursor move
autocmd({ "CursorMoved" }, {
	group = "global",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
-- save session
autocmd({ "VimLeave" }, {
	group = "global",
	command = "StoreSession",
})

--------------------------------------------------------------------------------
--                                 Filetypes                                  --
--------------------------------------------------------------------------------
augroup("markdown", { clear = true })
autocmd({ "FileType" }, {
	group = "markdown",
	pattern = "markdown",
	callback = function()
		vim.cmd("setlocal spell")
		vim.cmd('syntax match markdownIgnore "\\v\\w_\\w"')
	end,
})


augroup("python", { clear = true })
autocmd({ "Filetype" }, {
	group = "python",
	pattern = "*.python",
	command = "setlocal indentkeys-=<:> indentkeys-=:",
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
	pattern = "*.astro",
	command = "setlocal commentstring=<!--%s-->",
})
