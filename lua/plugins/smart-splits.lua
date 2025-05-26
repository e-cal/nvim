return {
	"mrjones2014/smart-splits.nvim",
	keys = {
		{ "<M-h>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>", desc = "move left" },
		{ "<M-l>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>", desc = "move right" },
		{ "<M-k>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>", desc = "move up" },
		{ "<M-j>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>", desc = "move down" },
		{ "<M-H>", "<cmd>lua require('smart-splits').resize_left()<cr>", desc = "resize left" },
		{ "<M-J>", "<cmd>lua require('smart-splits').resize_down()<cr>", desc = "resize down" },
		{ "<M-K>", "<cmd>lua require('smart-splits').resize_up()<cr>", desc = "resize up" },
		{ "<M-L>", "<cmd>lua require('smart-splits').resize_right()<cr>", desc = "resize right" },
		{ "<M-C-h>", "<cmd>lua require('smart-splits').swap_buf_left()<cr>", desc = "swap left" },
		{ "<M-C-j>", "<cmd>lua require('smart-splits').swap_buf_down()<cr>", desc = "swap down" },
		{ "<M-C-k>", "<cmd>lua require('smart-splits').swap_buf_up()<cr>", desc = "swap up" },
		{ "<M-C-l>", "<cmd>lua require('smart-splits').swap_buf_right()<cr>", desc = "swap right" },
	},
}
