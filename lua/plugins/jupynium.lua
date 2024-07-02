return {
	"kiyoon/jupynium.nvim",
	-- build = "source $VIRTUALENV_HOME/nvim/bin/activate && pip install .",
	dependencies = {
		"rcarriga/nvim-notify",
		"stevearc/dressing.nvim",
	},
	opts = {
		jupyter_command = "LD_LIBRARY_PATH=/opt/cuda/lib64:/opt/cuda-11.7/lib64:/run/opengl-driver/lib:$NIX_LD_LIBRARY_PATH jupyter",
		use_default_keybindings = false,
		-- syntax_highlight = { enable = false },
		notify = {
			ignore = {
				"download_ipynb",
				-- "error_download_ipynb",
				-- "attach_and_init",
				-- "error_close_main_page",
				-- "notebook_closed",
			},
		},
		jupynium_file_pattern = { "*.nb.*" },
		auto_attach_to_server = {
			enable = true,
			file_pattern = { "*.nb.*", "*.md" },
		},
	},
	config = function(opts)
		require("jupynium").setup(opts)
		local map = vim.keymap.set
		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd

		augroup("jupynium", { clear = true })
		autocmd({ "BufEnter" }, {
            pattern = "*.nb.*",
			callback = function(event)
				vim.cmd([[hi clear JupyniumMarkdownCellContent]])
				local buf_id = event.buf

				map(
					"n",
					"<space>js",
					"<cmd>JupyniumAttachToServer<cr><cmd>sleep 1<cr><cmd>JupyniumStartSync<cr>",
					-- "<cmd>JupyniumStartSync<cr>",
					{ buffer = buf_id, desc = "Jupynium scroll to cell" }
				)

				map({ "n", "x" }, "<space>jc", "i# %%<cr>", { buffer = buf_id, desc = "new cell" })
				map(
					{ "n", "x" },
					"<space>jm",
					'i# %% [markdown]<cr>"""<esc>yypO',
					{ buffer = buf_id, desc = "new cell" }
				)

				map(
					{ "n", "x" },
					"<space>x",
					"<cmd>JupyniumExecuteSelectedCells<CR>",
					{ buffer = buf_id, desc = "Jupynium execute selected cells" }
				)
				map(
					{ "n", "x" },
					"<space>jC",
					"<cmd>JupyniumClearSelectedCellsOutputs<CR>",
					{ buffer = buf_id, desc = "Jupynium clear selected cells" }
				)
				map(
					{ "n", "x" },
					"<space>jo",
					"<cmd>JupyniumToggleSelectedCellsOutputsScroll<cr>",
					{ buffer = buf_id, desc = "Jupynium toggle selected cell output scroll" }
				)

				map(
					{ "n" },
					"<space>K",
					"<cmd>JupyniumKernelHover<cr>",
					{ buffer = buf_id, desc = "Jupynium hover (inspect a variable)" }
				)
				map(
					{ "n", "x", "o" },
					"[j",
					"<cmd>lua require'jupynium.textobj'.goto_previous_cell_separator()<cr>",
					{ buffer = buf_id, desc = "Go to previous Jupynium cell" }
				)
				map(
					{ "n", "x", "o" },
					"]j",
					"<cmd>lua require'jupynium.textobj'.goto_next_cell_separator()<cr>",
					{ buffer = buf_id, desc = "Go to next Jupynium cell" }
				)

				-- text objects
				map(
					{ "x", "o" },
					"aj",
					"<cmd>lua require'jupynium.textobj'.select_cell(true, false)<cr>",
					{ buffer = buf_id, desc = "Select around Jupynium cell" }
				)
				map(
					{ "x", "o" },
					"ij",
					"<cmd>lua require'jupynium.textobj'.select_cell(false, false)<cr>",
					{ buffer = buf_id, desc = "Select inside Jupynium cell" }
				)
				map(
					{ "x", "o" },
					"aJ",
					"<cmd>lua require'jupynium.textobj'.select_cell(true, true)<cr>",
					{ buffer = buf_id, desc = "Select around Jupynium cell (include next cell separator)" }
				)
				map(
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
	end,
}
