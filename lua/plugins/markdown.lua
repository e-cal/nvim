return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
	keys = {
		{ "<leader>mp", "<cmd>PreviewDoc<cr>", desc = "toggle preview" },
		{ "<leader>ms", "1z=", desc = "fix spelling" },
		{ "<leader>mz", "mz<cmd>CleanText<cr>'z", desc = "clean text" },
		{ "<leader>mc", "<cmd>silent !md2pdf %<cr>", desc = "compile" },
	},
}
