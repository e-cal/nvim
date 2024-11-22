return {
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{ "neovim/nvim-lspconfig", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"mbbill/undotree",
		event = "VeryLazy",
		keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "undo tree" } },
	},
	{
		"utilyre/sentiment.nvim", -- bracket pair matching
		event = "VeryLazy",
		enabled = function()
			local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
			if ok and stats and stats.size > max_filesize then
			    print("disabled sentiment (bracket matching) for large file")
				return false
			end
			return true
		end,
		config = function()
			require("sentiment").setup()
			vim.cmd(
				string.format(
					"highlight MatchParen cterm=bold gui=bold guifg=%s guibg=%s",
					Utils.get_hl("Constant", "fg"),
					Utils.get_hl("Normal", "bg")
				)
			)
		end,
		init = function()
			vim.g.loaded_matchparen = 1
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
