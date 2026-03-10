return {
	"nvim-telescope/telescope.nvim",
    enabled = false,
	lazy = false,
	dependencies = {
		{
			"natecraddock/telescope-zf-native.nvim",
			build = "make",
		},
		{
			"danielfalk/smart-open.nvim",
			branch = "0.2.x",
			dependencies = {
				"kkharji/sqlite.lua",
			},
		},
	},
	opts = {
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
		},
		pickers = {
			find_files = {
				find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--follow" },
				follow = true,
				hidden = true,
				git_ignore = false,
				no_ignore = true,
				file_ignore_patterns = {
					"^%.git/",
					"^%.venv/",
					"^%.telescopeignore",
					"node_modules/",
                    "__pycache__/",
				},
				deprioritize_patterns = {
					"README.md",
					"tests",
					"scripts",
					"pyproject.toml",
				},
				deprioritize_default_penalty = 0.1,
			},
			buffers = {
				mappings = {
					i = { ["<c-d>"] = "delete_buffer" },
					n = { ["<c-d>"] = "delete_buffer" },
				},
			},
		},
		extensions = {
			["zf-native"] = {
				file = { enable = true, highlight_results = true, match_filename = true },
				generic = { enable = true, highlight_results = true },
			},
			smart_open = {
				match_algorithm = "fzy",
				open_buffer_indicators = { previous = "󰎂 ", others = "󱋡 " },
			},
		},
	},
	config = function(_, opts)
		local actions = require("telescope.actions")

		-- Merge extra mappings
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

		-- Read .telescopeignore and extend ignore patterns
		local function get_git_root()
			local dot_git = vim.fn.finddir(".git", ".;")
			return dot_git ~= "" and vim.fn.fnamemodify(dot_git, ":h") or nil
		end
		local root = get_git_root() or vim.fn.getcwd()
		local ignore_file = root .. "/.telescopeignore"

		local f = io.open(ignore_file, "r")
		if f then
			local patterns = {}
			for line in f:lines() do
				line = line:gsub("^%s*(.-)%s*$", "%1")
				if line ~= "" and not line:match("^#") then
					table.insert(patterns, line)
				end
			end
			f:close()
			local picker = opts.pickers.find_files
			picker.file_ignore_patterns = picker.file_ignore_patterns or {}
			vim.list_extend(picker.file_ignore_patterns, patterns)
		end

		vim.g.sqlite_clib_path = "/nix/store/6yawzw96lhv44d6rfkk8l5k22srfc81q-sqlite-3.51.1/lib/libsqlite3.dylib"

		require("telescope").setup(opts)
		require("telescope").load_extension("zf-native")
		require("telescope").load_extension("smart_open")
	end,
	keys = {
		{
			"<leader>o",
			function()
				require("telescope").extensions.smart_open.smart_open({ filename_first = false })
			end,
			desc = "open",
		},
		{ "<leader>tf", "<cmd>Telescope find_files<cr>", desc = "open (all files)" },
		{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "buffers" },
		{ "<leader>t.", "<cmd>TelescopeSearchDotfiles<cr>", desc = "config" },
		{ "<leader>tg", "<cmd>Telescope git_status<cr>", desc = "git changes" },
		{ "<leader>tb", "<cmd>Telescope buffers<cr>", desc = "buffers" },
		{ "<leader>tH", "<cmd>Telescope command_history<cr>", desc = "cmd history" },
		{ "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "help" },
		{ "<leader>ti", "<cmd>Telescope media_files<cr>", desc = "media" },
		{ "<leader>tm", "<cmd>Telescope marks<cr>", desc = "marks" },
		{ "<leader>tM", "<cmd>Telescope man_pages<cr>", desc = "man pages" },
		{ "<leader>to", "<cmd>Telescope vim_options<cr>", desc = "options" },
		{ "<leader>tT", "<cmd>Telescope live_grep<cr>", desc = "text" },
		{ "<leader>tF", "<cmd>TelescopeSearchDir<cr>", desc = "search from" },
		{ "<leader>tr", "<cmd>Telescope oldfiles<cr>", desc = "recents" },
		{ "<leader>tp", "<cmd>Telescope registers<cr>", desc = "registers" },
		{ "<leader>te", "<cmd>Telescope file_browser<cr>", desc = "fuzzy explorer" },
		{ "<leader>tc", "<cmd>Telescope colorscheme<cr>", desc = "colorschemes" },
		{ "<leader>tq", "<cmd>Telescope quickfix<cr>", desc = "quickfix" },
		{ "<leader>ts", "<cmd>Telescope treesitter<cr>", desc = "symbols" },
		{ "<leader>tS", "<cmd>Telescope aerial<cr>", desc = "aerial" },
		{ "<leader>t/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "fuzzy search" },
		{
			"<leader>tt",
			function()
				require("telescope.builtin").grep_string({
					search = vim.fn.input("Grep > "),
				})
			end,
			desc = "grep text",
		},
		{ "<leader>t", "<cmd>Telescope grep_string<cr>", mode = "v", desc = "search selection" },
		{ "<leader>s", ":!awk '{print length, $0}' | sort -n | cut -d' ' -f2-<cr>gv", mode = "v", desc = "sort selection by length" },
	},
}
