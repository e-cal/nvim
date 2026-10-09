return {
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{ "norcalli/nvim-colorizer.lua", opts = {}, event = "VeryLazy" },
	{
		"catppuccin/nvim",
        name = "catppuccin",
		priority = 100,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				integrations = { alpha = true },
			})
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
        event = "VeryLazy",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "_" },
				topdelete = { text = "▔" },
				changedelete = { text = "▎" },
				untracked = { text = "┆" },
			},
		},
	},
}
