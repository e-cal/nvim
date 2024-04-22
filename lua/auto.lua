local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
--                                   Global                                   --
--------------------------------------------------------------------------------
augroup("global", { clear = true })
autocmd({ "VimLeave" }, { group = "global", command = "StoreSession" })
autocmd({ "BufEnter" }, { group = "global", command = "LspStart" })
autocmd(
	{ "BufWinEnter", "BufRead", "BufNewFile" },
	{ group = "global", command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t" }
)
autocmd({ "CursorMoved" }, {
	group = "global",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
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
		vim.cmd("set sw=2 sts=2 ts=2")
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

augroup("remote_sync", { clear = true })
-- autocmd({ "BufWritePost" }, {
-- 	group = "remote_sync",
-- 	pattern = {
-- 		"*/projects/high-stakes-conf/*",
-- 	},
-- 	callback = function()
-- 		local remote_host = "xz2"
--
--         vim.cmd.redraw() -- prevent asking for user input on print
-- 		vim.notify("Copying to " .. remote_host .. "...", vim.log.levels.INFO)
--
-- 		local full_path = vim.fn.expand("%:p")
-- 		local relative_to_home = string.gsub(full_path, vim.env.HOME, "")
-- 		local remote_path = string.gsub(relative_to_home, "/projects", "")
-- 		local remote = remote_host .. ":~" .. remote_path
-- 		local cmd = "scp " .. full_path .. " " .. remote
--
-- 		vim.fn.jobstart(cmd, {
-- 			detach = true,
-- 			on_exit = function(_, code)
-- 				if code == 0 then
-- 					vim.notify("File copied to " .. remote, vim.log.levels.INFO)
-- 				else
-- 					vim.notify("Failed to copy file to " .. remote, vim.log.levels.ERROR)
-- 				end
-- 			end,
-- 		})
-- 	end,
-- })
