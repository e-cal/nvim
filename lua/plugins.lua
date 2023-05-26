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
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- LSP
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/null-ls.nvim")
	use("github/copilot.vim")
	use({
		"williamboman/mason.nvim",
		run = ":MasonUpdate",
		requires = { "williamboman/mason-lspconfig.nvim" },
	})

	-- Autocompletion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("kdheepak/cmp-latex-symbols")
	use("hrsh7th/cmp-nvim-lsp-signature-help")

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	-- Navigation
	use({
		"nvim-neo-tree/neo-tree.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
		},
	})
	use("ggandor/lightspeed.nvim")
	use("numToStr/Navigator.nvim")
	use("theprimeagen/harpoon")
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-telescope/telescope-fzy-native.nvim" },
			{ "nvim-telescope/telescope-media-files.nvim" },
			{ "nvim-telescope/telescope-file-browser.nvim" },
		},
	})
	use("luukvbaal/nnn.nvim")
	use("stevearc/aerial.nvim")

	-- Convenience
	use("folke/which-key.nvim")
	use("windwp/nvim-autopairs")
	use("terrortylor/nvim-comment")
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("lukas-reineke/indent-blankline.nvim")
	use("untitled-ai/jupyter_ascending.vim")
	use("mbbill/undotree")
	use("kevinhwang91/nvim-bqf")
	use("folke/trouble.nvim")
	use({ "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()" })
	use("lervag/vimtex")
	use("nvim-treesitter/nvim-treesitter-context")

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("mfussenegger/nvim-dap-python")

	-- Theming
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use("nvim-treesitter/playground")
	use("goolord/alpha-nvim")

	-- Colorschemes
	use("theniceboy/nvim-deus")
	use("arcticicestudio/nord-vim")
	use("rakr/vim-two-firewatch")
	use("rebelot/kanagawa.nvim")
	use("JoosepAlviste/palenightfall.nvim")
	use("catppuccin/nvim")
end)
