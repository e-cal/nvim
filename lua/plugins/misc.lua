return {
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{ "neovim/nvim-lspconfig", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"rcarriga/nvim-notify",
		lazy = false,
		opts = {
			background_colour = "CursorLine",
			render = "minimal",
			stages = "fade",
			top_down = false,
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = notify
		end,
	},
	{
		"mbbill/undotree",
		event = "VeryLazy",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undo tree" } },
	},
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("ts_context_commentstring").setup({ enable_autocmd = false })
			require("Comment.ft").set({ "nu", "nushell" }, "# %s")
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
			-- idk why keys doesn't work for these but it don't
			vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { desc = "comment" })
			vim.api.nvim_set_keymap("v", "<C-_>", "gc", { desc = "comment" })
			vim.api.nvim_set_keymap("v", "<leader>/", "gc", { desc = "comment" })
		end,
	},
	{
		"tar80/matchwith.nvim", -- bracket pair matching
		-- Pinned to the reviewed commit; review upstream changes before bumping.
		commit = "70bde09e0c1c89375b1fd89a6800973fe8798ec6",
		event = "VeryLazy",
		enabled = function()
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
			if ok and stats and stats.size > max_filesize then
				print("disabled matchwith (bracket matching) for large file")
				return false
			end
			return true
		end,
		config = function()
			require("matchwith").setup({ show_parent = true })

			-- Highlight the pair under the cursor and the pair around the cursor
			-- the same way. Reapply after a colorscheme change clears them.
			local function set_highlights()
				local hl = { fg = Utils.get_hl("Constant", "fg"), bg = Utils.get_hl("Normal", "bg"), bold = true }
				for _, group in ipairs({ "MatchParen", "Matchwith", "MatchwithParent" }) do
					vim.api.nvim_set_hl(0, group, hl)
				end
			end
			set_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
		end,
	},
	{
		"nvimtools/hydra.nvim",
		config = function()
			local hydra = require("hydra")
			hydra({
				body = "zl",
				name = "scroll",
				mode = "n",
				heads = { { "l", "zl" }, { "h", "zh" }, { "L", "10zl" }, { "H", "10zh" } },
				config = { invoke_on_body = true },
			})
			hydra({
				body = "zh",
				name = "scroll",
				mode = "n",
				heads = { { "l", "zl" }, { "h", "zh" }, { "L", "10zl" }, { "H", "10zh" } },
				config = { invoke_on_body = true },
			})
			hydra({
				body = "zL",
				name = "scroll",
				mode = "n",
				heads = { { "l", "zl" }, { "h", "zh" }, { "L", "10zl" }, { "H", "10zh" } },
				config = { invoke_on_body = true },
			})
			hydra({
				body = "zH",
				name = "scroll",
				mode = "n",
				heads = { { "l", "zl" }, { "h", "zh" }, { "L", "10zl" }, { "H", "10zh" } },
				config = { invoke_on_body = true },
			})
		end,
	},
}
