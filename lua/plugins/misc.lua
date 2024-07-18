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
		"utilyre/sentiment.nvim",
		event = "VeryLazy",
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
				name = "scroll",
				mode = "n",
				body = "zl",
				heads = {
					{ "l", "zl" },
					{ "h", "zh" },
				},
				config = { invoke_on_body = true },
			})
			hydra({
				name = "scroll",
				mode = "n",
				body = "zh",
				heads = {
					{ "l", "zl" },
					{ "h", "zh" },
				},
				config = { invoke_on_body = true },
			})
		end,
	},
}
