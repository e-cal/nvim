return {
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
}
