return {
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{ "neovim/nvim-lspconfig", event = "VeryLazy" },
	{ "stevearc/conform.nvim", event = "VeryLazy" },
	{
		"williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
		dependencies = {
			{ "williamboman/mason.nvim", build = ":MasonUpdate" },
		},
	},
}
