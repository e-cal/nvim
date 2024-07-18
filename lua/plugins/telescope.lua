return {
	"nvim-telescope/telescope.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	opts = {
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
		},
		pickers = {
			find_files = {
				follow = true,
			},
		},
	},
	config = function(_, opts)
		local actions = require("telescope.actions")
		local extra_opts = {
			defaults = {
				mappings = {
					i = {
						["<c-j>"] = actions.move_selection_next,
						["<c-k>"] = actions.move_selection_previous,
					},
				},
			},
		}
		opts = vim.tbl_deep_extend("force", opts, extra_opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("fzf")
	end,
	keys = {
		{ "<leader>o", "<cmd>Telescope find_files<cr>", desc = "open" },
		{ "<leader>t.", "<cmd>TelescopeSearchDotfiles<cr>", desc = "config" },
		{ "<leader>tF", "<cmd>Telescope filetypes<cr>", desc = "filetypes" },
		{ "<leader>tg", "<cmd>Telescope git_branches<cr>", desc = "git branches" },
		{ "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "buffers" },
		{ "<leader>tH", "<cmd>Telescope command_history<cr>", desc = "cmd history" },
		{ "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "help" },
		{ "<leader>ti", "<cmd>Telescope media_files<cr>", desc = "media" },
		{ "<leader>tm", "<cmd>Telescope marks<cr>", desc = "marks" },
		{ "<leader>tM", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
		{ "<leader>to", "<cmd>Telescope vim_options<cr>", desc = "options" },
		{ "<leader>tT", "<cmd>Telescope live_grep<cr>", desc = "text" },
		{ "<leader>tf", "<cmd>TelescopeSearchDir<cr>", desc = "search from" },
		{ "<leader>tr", "<cmd>Telescope oldfiles<cr>", desc = "recents" },
		{ "<leader>tp", "<cmd>Telescope registers<cr>", desc = "registers" },
		{ "<leader>te", "<cmd>Telescope file_browser<cr>", desc = "fuzzy explorer" },
		{ "<leader>tc", "<cmd>Telescope colorscheme<cr>", desc = "colorschemes" },
		{ "<leader>tq", "<cmd>Telescope quickfix<cr>", desc = "quickfix" },
		{ "<leader>ts", "<cmd>Telescope treesitter<cr>", desc = "symbols" },
		{ "<leader>tS", "<cmd>Telescope aerial<cr>", desc = "aerial" },
		{
			"<leader>tt",
			function()
				require("telescope.builtin").grep_string({
					search = vim.fn.input("Grep > "),
				})
			end,
			desc = "grep text",
		},
		{ "<leader>s", "<cmd>Telescope grep_string<cr>", mode = "v", desc = "search selection" },
	},
}
