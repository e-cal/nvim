return {
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
}
