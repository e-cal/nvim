return {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
		ensure_installed = {
			"lua_ls",
			"pyright",
			"ruff",
			"ts_ls",
			"gopls",
		},
	},
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
