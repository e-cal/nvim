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

local packer = require("packer")
packer.init({
	compile_path = vim.fn.stdpath("config") .. "/lua/plugins/packer_compiled.lua",
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	use({
		-- "/home/ecal/projects/askgpt.nvim",
        "e-cal/askgpt.nvim",
		config = function()
			require("askgpt").setup()
            vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>Ask<cr>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("v", "<C-g>", "<cmd>Ask<cr>", { noremap = true, silent = true })
		end,
	})

	-- Utils
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	-- LSP
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/null-ls.nvim")
	use({
		"williamboman/mason.nvim",
		run = ":MasonUpdate",
		requires = { "williamboman/mason-lspconfig.nvim" },
	})
	use("zbirenbaum/copilot.lua")
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
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
	use("stevearc/aerial.nvim")
	use({
		"luukvbaal/nnn.nvim",
		config = function()
			require("nnn").setup()
		end,
	})

	-- Convenience
	use("folke/which-key.nvim")
	use("windwp/nvim-autopairs")
	use("terrortylor/nvim-comment")
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")
	use("lukas-reineke/indent-blankline.nvim")
	use("mbbill/undotree")
	use("kevinhwang91/nvim-bqf")
	use("folke/trouble.nvim")
	use({ "iamcco/markdown-preview.nvim", run = ":call mkdp#util#install()" })
	use("nvim-treesitter/nvim-treesitter-context")
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})

	-- Theming
	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use("goolord/alpha-nvim")
	use("catppuccin/nvim")
end)
