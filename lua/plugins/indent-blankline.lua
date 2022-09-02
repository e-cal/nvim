-- OOC = out of context, IC = in context
vim.cmd([[highlight IndentBlanklineOOC guifg=#46474A gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIC guifg=#F4C069 gui=nocombine]])

require("indent_blankline").setup({
	enabled = IndentGuide,
	-- char = "▏",
	char = "⎸",
	context_char = "│",
	-- char_blankline = " ",
	space_char_blankline = " ",
	use_treesitter = true,
	show_current_context = true,
	show_current_context_start = false,
	char_highlight_list = {
		"IndentBlanklineOOC",
	},
	context_highlight_list = {
		"IndentBlanklineIC",
	},
})
