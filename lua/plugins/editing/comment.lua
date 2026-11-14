return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	config = function()
		require("ts_context_commentstring").setup({ enable_autocmd = false })
		require("Comment.ft").set({ "nu", "nushell" }, "# %s")
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
	keys = {
		{ "<leader>/", "gcc", remap = true, desc = "comment" },
		{ "<C-_>", "gc", mode = "v", remap = true, desc = "comment" },
		{ "<leader>/", "gc", mode = "v", remap = true, desc = "comment" },
	},
}
