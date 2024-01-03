return {
	{ "numToStr/Navigator.nvim", event = "VeryLazy", opts = {} },
	{ "theprimeagen/harpoon", event = "VeryLazy" },
	{ "folke/flash.nvim", event = "VeryLazy" },
	{ "luukvbaal/nnn.nvim", event = "VeryLazy", opts = {} },
	{ "folke/trouble.nvim", event = "VeryLazy", opts = { use_diagnostic_signs = true } },
	-- ========================================================================
	-- aerial
	-- ========================================================================
	{
		"stevearc/aerial.nvim",
		event = "VeryLazy",
		opts = {
			nav = {
				preview = true,
				keymaps = {
					["<esc>"] = "actions.close",
					["q"] = "actions.close",
				},
			},
		},
	},
	-- ========================================================================
	-- telescope
	-- ========================================================================
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
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
	},
	-- ========================================================================
	-- neotree
	-- ========================================================================
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		opts = {
			close_if_last_window = true,
			enable_diagnostics = false,
			window = { -- all neo-tree windows
				width = 20,
				mappings = {
					["<cr>"] = "open",
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					["<esc>"] = "revert_preview",
					["L"] = "focus_preview",
					["s"] = "open_split",
					["v"] = "open_vsplit",
					["Y"] = { "copy", config = { show_path = "absolute" } },
					["m"] = { "move", config = { show_path = "relative" } },
					["n"] = "next_source",
					["<tab>"] = "next_source",
					["o"] = "system_open",
				},
			},
			filesystem = { -- file tree specific
				window = {
					mappings = {
						["h"] = "navigate_up",
						["l"] = "set_root",
						["H"] = "toggle_hidden",
					},
				},
			},
			buffers = { -- buffer tree specific
				window = {
					mappings = {
						["h"] = "navigate_up",
						["l"] = "set_root",
						["d"] = "buffer_delete",
					},
				},
			},
			default_component_configs = {
				container = { enable_character_fade = false },
				indent = { padding = 0 },
				modified = { symbol = "󱇨" },
				git_status = {
					symbols = {
						deleted = "",
						renamed = "󰁔",
						untracked = "",
						ignored = "◌",
						unstaged = "",
						staged = "󰈖",
						conflict = "",
					},
				},
			},
			commands = {
				system_open = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.api.nvim_command(string.format("silent !open '%s'", path))
				end,
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(_)
						require("neo-tree").close_all()
					end,
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)

			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
			vim.cmd([[
                highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
                highlight! link NeoTreeDirectoryName NvimTreeFolderName
                highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
                highlight! link NeoTreeRootName NvimTreeRootFolder
                highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
                highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
            ]])
		end,
	},
}
