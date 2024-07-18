return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "_" },
			topdelete = { text = "▔" },
			changedelete = { text = "▎" },
			untracked = { text = "┆" },
		},
	},
	keys = {
		{ "<leader>gd", "<cmd>Git preview_hunk<cr>", desc = "preview hunk diff" },
		{ "<leader>gD", "<cmd>Git diffthis<CR>", desc = "file diff" },
		{ "<leader>gr", "<cmd>Git reset_hunk<CR>", desc = "reset hunk" },
		{ "<leader>gR", "<cmd>Git reset_buffer<CR>", desc = "reset buffer" },
		{ "<leader>gn", "<cmd>Git next_hunk<CR>", desc = "next hunk" },
		{ "<leader>gp", "<cmd>Git prev_hunk<CR>", desc = "prev hunk" },
		{ "<leader>gb", "<cmd>Git blame_line<CR>", desc = "blame" },
	},
}
