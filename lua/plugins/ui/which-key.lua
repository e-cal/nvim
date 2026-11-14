return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		icons = {
			breadcrumb = "»",
			separator = "->",
			group = "",
			mappings = false,
		},
		spec = {
			{ "<leader>a", group = "agent", mode = { "n", "v" } },
			{ "<leader>9", group = "99", mode = { "n", "v" } },
			{ "<leader>c", group = "chat", mode = { "n", "v" } },
			{ "<leader>L", group = "llm", mode = { "n", "v" } },
			{ "<leader>t", group = "telescope" },
			{ "<leader>w", group = "window" },
			{ "<leader>r", group = "repl" },
			{ "<leader>l", group = "lsp" },
			{ "<leader>lt", group = "latex" },
			{ "<leader>g", group = "git" },
		},
	},
}
