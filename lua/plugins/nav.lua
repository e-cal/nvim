return {
	{ "numToStr/Navigator.nvim", event = "VeryLazy", opts = {} },
	{ "theprimeagen/harpoon", event = "VeryLazy" },
	{ "folke/flash.nvim", event = "VeryLazy" },
	{
		"stevearc/aerial.nvim", -- symbols
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
	},
}
