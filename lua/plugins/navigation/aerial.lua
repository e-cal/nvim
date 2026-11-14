return {
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
	keys = { { "<leader>S", "m`<cmd>AerialNavToggle<cr>", desc = "aerial" } },
}
