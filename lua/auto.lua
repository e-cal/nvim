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

augroup("jupynium", { clear = true })
autocmd({ "BufEnter" }, {
	pattern = require("jupynium.options").opts.jupynium_file_pattern,
	callback = function(event)
		vim.cmd([[hi clear JupyniumMarkdownCellContent]])
		local buf_id = event.buf
		vim.keymap.set(
			{ "n", "x" },
			"<space>x",
			"<cmd>JupyniumExecuteSelectedCells<CR>",
			{ buffer = buf_id, desc = "Jupynium execute selected cells" }
		)

		-- j = {
		-- 	name = "jupynium",
		-- 	s = { "<cmd>JupyniumStartSync<cr>", "sync" },
		--                 c = { "i# %%<cr><esc>" , "new cell" },
		-- },
		vim.keymap.set({ "n", "x" }, "<space>jc", "i# %%<cr>", { buffer = buf_id, desc = "new cell" })
		vim.keymap.set({ "n", "x" }, "<space>jm", 'i# %% [markdown]<cr>"""<esc>yypO', { buffer = buf_id, desc = "new cell" })
		vim.keymap.set(
			{ "n", "x" },
			"<space>jC",
			"<cmd>JupyniumClearSelectedCellsOutputs<CR>",
			{ buffer = buf_id, desc = "Jupynium clear selected cells" }
		)
		vim.keymap.set(
			{ "n" },
			"<space>K",
			"<cmd>JupyniumKernelHover<cr>",
			{ buffer = buf_id, desc = "Jupynium hover (inspect a variable)" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"<space>js",
			"<cmd>JupyniumAttachToServer<cr><cmd>sleep 1<cr><cmd>JupyniumStartSync<cr>",
			{ buffer = buf_id, desc = "Jupynium scroll to cell" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"<space>jf",
			"<cmd>JupyniumScrollToCell<cr>",
			{ buffer = buf_id, desc = "Jupynium scroll to cell" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"<space>jo",
			"<cmd>JupyniumToggleSelectedCellsOutputsScroll<cr>",
			{ buffer = buf_id, desc = "Jupynium toggle selected cell output scroll" }
		)
		vim.keymap.set("", "<PageUp>", "<cmd>JupyniumScrollUp<cr>", { buffer = buf_id, desc = "Jupynium scroll up" })
		vim.keymap.set(
			"",
			"<PageDown>",
			"<cmd>JupyniumScrollDown<cr>",
			{ buffer = buf_id, desc = "Jupynium scroll down" }
		)

		vim.keymap.set(
			{ "n", "x", "o" },
			"[j",
			"<cmd>lua require'jupynium.textobj'.goto_previous_cell_separator()<cr>",
			{ buffer = buf_id, desc = "Go to previous Jupynium cell" }
		)
		vim.keymap.set(
			{ "n", "x", "o" },
			"]j",
			"<cmd>lua require'jupynium.textobj'.goto_next_cell_separator()<cr>",
			{ buffer = buf_id, desc = "Go to next Jupynium cell" }
		)
		vim.keymap.set(
			{ "x", "o" },
			"aj",
			"<cmd>lua require'jupynium.textobj'.select_cell(true, false)<cr>",
			{ buffer = buf_id, desc = "Select around Jupynium cell" }
		)
		vim.keymap.set(
			{ "x", "o" },
			"ij",
			"<cmd>lua require'jupynium.textobj'.select_cell(false, false)<cr>",
			{ buffer = buf_id, desc = "Select inside Jupynium cell" }
		)
		vim.keymap.set(
			{ "x", "o" },
			"aJ",
			"<cmd>lua require'jupynium.textobj'.select_cell(true, true)<cr>",
			{ buffer = buf_id, desc = "Select around Jupynium cell (include next cell separator)" }
		)
		vim.keymap.set(
			{ "x", "o" },
			"iJ",
			"<cmd>lua require'jupynium.textobj'.select_cell(false, true)<cr>",
			{ buffer = buf_id, desc = "Select inside Jupynium cell (include next cell separator)" }
		)
	end,
})
autocmd({ "VimLeave" }, {
	group = "jupynium",
	pattern = require("jupynium.options").opts.jupynium_file_pattern,
	command = "!rm Untitled*.ipynb",
})

-- Remote syncing
augroup("remote_sync", { clear = true })
autocmd({ "BufWritePost" }, {
	group = "remote_sync",
	pattern = {
		"*/projects/high-stakes-conf/*",
	},
	callback = function()
		local remote_host = "xz2"

		vim.cmd.redraw() -- prevent asking for user input on print
		vim.notify("Copying to " .. remote_host .. "...", vim.log.levels.INFO)

		local full_path = vim.fn.expand("%:p")
		local relative_to_home = string.gsub(full_path, vim.env.HOME, "")
		local remote_path = string.gsub(relative_to_home, "/projects", "")
		local remote = remote_host .. ":~" .. remote_path
		local cmd = "scp " .. full_path .. " " .. remote

		vim.fn.jobstart(cmd, {
			detach = true,
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("File copied to " .. remote, vim.log.levels.INFO)
				else
					vim.notify("Failed to copy file to " .. remote, vim.log.levels.ERROR)
				end
			end,
		})
	end,
})
