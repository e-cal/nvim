return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function(opts)
		local wk = require("which-key")
		wk.setup({
			icons = {
				breadcrumb = "»",
				separator = "->",
				group = "",
				mappings = false,
			},
		})
		wk.add({
			{ "<leader>c", group = "chat", mode = { "n", "v" } },
			{ "<leader>t", group = "telescope" },
			{ "<leader>m", group = "markdown" },
			{ "<leader>w", group = "window" },
			{ "<leader>r", group = "repl" },
			{ "<leader>l", group = "lsp" },
			{ "<leader>g", group = "git" },
		})
	end,
}
