return {
	{ "numToStr/Navigator.nvim", event = "VeryLazy", opts = {} },
	{ "theprimeagen/harpoon", event = "VeryLazy" },
	{ "folke/flash.nvim", event = "VeryLazy" },
	{ "luukvbaal/nnn.nvim", event = "VeryLazy", opts = {} },
	{ "folke/trouble.nvim", event = "VeryLazy", opts = { use_diagnostic_signs = true } },
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
	},
}
