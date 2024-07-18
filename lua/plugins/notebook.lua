return {
	{
		"GCBallesteros/jupytext.nvim",
		-- lazy = false,
		opts = {
			custom_language_formatting = {
				python = {
					extension = "qmd",
					style = "quarto",
					force_ft = "quarto", -- you can set whatever filetype you want here
				},
			},
		},
	},
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki", "quarto" },
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "norg" },
				},
				html = {
					enabled = false,
				},
				css = {
					enabled = false,
				},
			},
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
			tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
		},
	},
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "quarto", "markdown" },
		opts = {
			debug = false,
			closePreviewOnExit = true,
			lspFeatures = {
				enabled = true,
				chunks = "all", -- all, curly
				languages = { "r", "python", "julia", "bash", "html" },
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = true,
				default_method = "molten",
				never_run = { "yaml" },
			},
		},
		init = function()
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<leader>mr", runner.run_cell, { desc = "run cell", silent = true })
			vim.keymap.set("n", "<leader>ma", runner.run_above, { desc = "run cell and above", silent = true })
			vim.keymap.set("n", "<leader>mA", runner.run_all, { desc = "run all cells", silent = true })
			vim.keymap.set("n", "<leader>ml", runner.run_line, { desc = "run line", silent = true })
			-- vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range", silent = true })
			-- vim.keymap.set("n", "<leader>jA", function()
			-- 	runner.run_all(true)
			-- end, { desc = "run all cells of all languages", silent = true })
		end,
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		build = ":UpdateRemotePlugins",
		ft = { "quarto", "markdown" },
		init = function()
			vim.g.molten_auto_open_output = false
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
			vim.g.molten_output_virt_lines = true
			vim.g.molten_image_provider = "image.nvim"

			vim.keymap.set("n", "<leader>mi", "<cmd>MoltenInit<CR>", { desc = "evaluate operator" })
			vim.keymap.set("n", "<leader>me", "<cmd>MoltenEvaluateOperator<CR>", { desc = "evaluate operator" })
			vim.keymap.set("n", "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<CR>", { desc = "open output window" })
			-- vim.keymap.set("n", "<leader>mr", "<cmd>MoltenReevaluateCell<CR>", { desc = "re-eval cell" })
			vim.keymap.set("n", "<leader>mh", "<cmd>MoltenHideOutput<CR>", { desc = "close output window" })
			vim.keymap.set("n", "<leader>md", "<cmd>MoltenDelete<CR>", { desc = "delete Molten cell" })
			vim.keymap.set("n", "<leader>mx", "<cmd>MoltenOpenInBrowser<CR>", { desc = "open output in browser" })
			-- vim.keymap.set("v", "<leader>m", "<cmd>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection" })

			local hydra = require("hydra")
			local utils = require("utils")
			hydra({
				name = "jump",
				config = { invoke_on_body = true },
				mode = "n",
				body = "<leader>mj", -- this is the key that triggers the hydra
				heads = {
					{ "j", utils.keys("]b") },
					{ "k", utils.keys("[b") },
				},
			})

			local default_notebook = [[
{
"cells": [
 {
  "cell_type": "markdown",
  "metadata": {},
  "source": [
    ""
  ]
 }
],
"metadata": {
 "kernelspec": {
  "display_name": "Python 3",
  "language": "python",
  "name": "python3"
 },
 "language_info": {
  "codemirror_mode": {
    "name": "ipython"
  },
  "file_extension": ".py",
  "mimetype": "text/x-python",
  "name": "python",
  "nbconvert_exporter": "python",
  "pygments_lexer": "ipython3"
 }
},
"nbformat": 4,
"nbformat_minor": 5
}
]]

			local function new_notebook(filename)
				local path = filename .. ".ipynb"
				local file = io.open(path, "w")
				if file then
					file:write(default_notebook)
					file:close()
					vim.cmd("edit " .. path)
				else
					print("Error: Could not open new notebook file for writing.")
				end
			end

			vim.api.nvim_create_user_command("NewNotebook", function(opts)
				new_notebook(opts.args)
			end, { nargs = 1, complete = "file" })
		end,
	},
}
