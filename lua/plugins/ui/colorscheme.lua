return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 100,
	opts = {
		flavour = "macchiato",
		integrations = { alpha = true },
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd("colorscheme catppuccin")
	end,
}
