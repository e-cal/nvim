local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	execute("packadd packer.nvim")
end

-- Autocompile
vim.cmd("autocmd BufWritePost init.lua PackerCompile")

return require("packer").startup(function(use)
	-- Utils
	use("wbthomason/packer.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")

	-- LSP
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
	use("ray-x/lsp_signature.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-calc")
	use("kdheepak/cmp-latex-symbols")
	use("f3fora/cmp-spell")
	use("github/copilot.vim")

	-- Navigation
	use("kyazdani42/nvim-tree.lua")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use("ggandor/lightspeed.nvim")
	use("numToStr/Navigator.nvim")
	use("theprimeagen/harpoon")

	-- Convenience
	use("folke/which-key.nvim")
	use("windwp/nvim-autopairs")
	use("terrortylor/nvim-comment")
	use("kevinhwang91/nvim-bqf")
	use({ "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()" })
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("windwp/nvim-ts-autotag")
	use("lukas-reineke/indent-blankline.nvim")
	use("untitled-ai/jupyter_ascending.vim")
	use("mbbill/undotree")

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui") -- temporary while nvim-dap lacks a built-in ui
	use("mfussenegger/nvim-dap-python")

	-- Theming
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	-- use("romgrk/barbar.nvim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/playground")

	-- Colorschemes
	use("theniceboy/nvim-deus")
	use("arcticicestudio/nord-vim")
	use("rakr/vim-two-firewatch")
	use("rebelot/kanagawa.nvim")
	use("JoosepAlviste/palenightfall.nvim")
	use("catppuccin/nvim")
end)
