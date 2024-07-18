return {
	{
		"numToStr/Navigator.nvim",
		event = "VeryLazy",
		config = true,
		keys = {
			{ "<M-h>", "<cmd>lua require('Navigator').left()<cr>" },
			{ "<M-l>", "<cmd>lua require('Navigator').right()<cr>" },
			{ "<M-k>", "<cmd>lua require('Navigator').up()<cr>" },
			{ "<M-j>", "<cmd>lua require('Navigator').down()<cr>" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{ "s", "<cmd>lua require('flash').jump()<cr>" },
			{ "s", "<cmd>lua require('flash').jump()<cr>", mode = "x" },
			{ "s", "<cmd>lua require('flash').jump() <cr>", mode = "o" },
			{ "S", "<cmd>lua require('flash').treesitter() <cr>", mode = "n" },
			{ "r", "<cmd>lua require('flash').remote()<cr>", mode = "o" },
			{ "R", "<cmd>lua require('flash').treesitter_search()<cr>", mode = "o" },
			{ "R", "<cmd>lua require('flash').treesitter_search() <cr>", mode = "x" },
			{ "<c-s>", "<cmd>lua require('flash').toggle()<cr>", mode = "c" },
		},
	},
	{
		"stevearc/aerial.nvim",
		event = "VeryLazy",
		opts = {
			nav = {
				preview = true,
				keymaps = {
					["<esc>"] = "actions.close",
					["q"] = "actions.close",
				},
			},
		},
		keys = { { "<leader>S", "m`<cmd>AerialNavToggle<cr>", desc = "aerial" } },
	},
}
