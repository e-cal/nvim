return {
	{ "nvim-lua/popup.nvim", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },
	{ "neovim/nvim-lspconfig", event = "VeryLazy" },
	{ "mbbill/undotree", event = "VeryLazy" },
    { "tpope/vim-repeat", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"utilyre/sentiment.nvim", -- bracket highlighting
		event = "VeryLazy",
		init = function()
			vim.g.loaded_matchparen = 1
		end,
	},
}
