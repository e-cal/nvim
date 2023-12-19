local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
		"e-cal/askgpt.nvim",
		config = function()
			require("askgpt").setup()
			vim.api.nvim_set_keymap("n", "<C-g>", "<cmd>Ask<cr>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("v", "<C-g>", "<cmd>Ask<cr>", { noremap = true, silent = true })
		end,
	},
	-- Utils
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },

	-- LSP
	"neovim/nvim-lspconfig",
	"stevearc/conform.nvim",
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
	{ "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("plugins.copilot")
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.cmp")
		end,
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"kdheepak/cmp-latex-symbols",
	"hrsh7th/cmp-nvim-lsp-signature-help",

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip.config").setup({ enable_autosnippets = true })
			require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets" } })
		end,
	},
	"saadparwaiz1/cmp_luasnip",

	-- Navigation
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("plugins.neotree")
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"numToStr/Navigator.nvim",
		config = function()
			require("Navigator").setup()
		end,
	},
	"theprimeagen/harpoon",
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzy-native.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("plugins.telescope")
		end,
	},
	{
		"stevearc/aerial.nvim",
		config = function()
			require("plugins.aerial")
		end,
	},
	{
		"luukvbaal/nnn.nvim",
		config = function()
			require("nnn").setup()
		end,
	},

	-- Convenience
	{
		"folke/which-key.nvim",
		config = function()
			require("plugins.whichkey")
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("plugins.autopairs")
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
			vim.api.nvim_set_keymap("v", "<C-_>", "gb", {})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugins.gitsigns")
		end,
	},
	"tpope/vim-surround",
	"tpope/vim-repeat",
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugins.ibl")
		end,
	},
	"mbbill/undotree",
	{
		"kevinhwang91/nvim-bqf",
		config = function()
			require("plugins.bqf")
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({ use_diagnostic_signs = true })
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		build = ":call mkdp#util#install()",
		config = function()
			local g = vim.g

			g.mkdp_auto_close = 0
			g.mkdp_refresh_slow = 1
			g.mkdp_page_title = "${name}"
		end,
	},
	"nvim-treesitter/nvim-treesitter-context",
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	--
	--    -- Theming
	"kyazdani42/nvim-web-devicons",
	{
		"goolord/alpha-nvim",
		config = function()
			require("plugins.dashboard")
		end,
	},
	{
		"catppuccin/nvim",
		priority = 100,
		config = function()
			vim.g.catppuccin_flavour = "macchiato"
			vim.cmd("colorscheme catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("plugins.lualine")
		end,
		lazy = false,
		priority = 10,
	},
}

require("lazy").setup(plugins, {})
