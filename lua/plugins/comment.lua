return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		require("Comment").setup()
		-- idk why keys doesn't work for these but it don't
		vim.api.nvim_set_keymap("n", "<leader>/", "gcc", { desc = "comment" })
		vim.api.nvim_set_keymap("v", "<C-_>", "gc", { desc = "comment" })
		vim.api.nvim_set_keymap("v", "<leader>/", "gc", { desc = "comment" })
	end,
}
