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
				hidden = true,
				git_ignore = false,
				file_ignore_patterns = { "^.git/" },
			},
		},
	},
	config = function(_, opts)
		local actions = require("telescope.actions")

		-- Custom function to load project ignores
		local load_project_ignores = function()
			local project_ignore = {}
			local root = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1] or "")
			if root then
				local ignore_file = root .. "/.telescopeignore"
				if vim.fn.filereadable(ignore_file) == 1 then
					for line in io.lines(ignore_file) do
						if not line:match("^%s*#") and line ~= "" then
							-- Convert glob patterns to Lua patterns
							local pattern = line:gsub("[%%%[%]%^%$%(%)%.]", "%%%0"):gsub("%*", ".*"):gsub("%?", ".")
							table.insert(project_ignore, pattern)
						end
					end
				end
			end
			return project_ignore
		end
		-- Merge project ignores with defaults
		local original_find_files = opts.pickers.find_files or {}
		opts.pickers.find_files = vim.tbl_deep_extend("force", original_find_files, {
			file_ignore_patterns = load_project_ignores(),
		})

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
