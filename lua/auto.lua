local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
--                                   Global                                   --
--------------------------------------------------------------------------------
augroup("global", { clear = true })
autocmd({ "VimLeave" }, { group = "global", command = "StoreSession" })
autocmd({ "BufEnter" }, { group = "global", command = "LspStart" })
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
