return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
		ensure_installed = {
			"lua_ls",
			-- "pyright", -- temporarily disabled while trying ty
			"ruff",
			"ty",
			-- "biome", -- Mason installs latest Biome, which can violate npm's before-date guard.
			"ts_ls",
			"bashls",
		},
		automatic_enable = {
			exclude = {
				"pyright",
			},
		},
	},
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
