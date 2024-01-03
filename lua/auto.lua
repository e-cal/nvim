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
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.html", "*.css", "*.scss" },
	command = "setlocal ts=2 sw=2 sts=2",
})
