-- out of context
vim.cmd(string.format([[highlight IndentBlanklineOOC guifg=%s gui=nocombine]], Utils.get_hl("ColorColumn", "bg")))
-- in context
vim.cmd(
	string.format(
		[[highlight IndentBlanklineIC guifg=%s gui=nocombine]],
		Utils.brightness_modifier(Utils.get_hl("IndentBlanklineOOC", "fg"), 50)
	)
)

require("indent_blankline").setup({
	enabled = IndentGuide,
	-- char = "⎸",
	char = "│",
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
