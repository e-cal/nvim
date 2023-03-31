-- local extract_color = require("lualine.utils.utils").extract_color_from_hllist
-- comment_color = extract_color("fg", { "Comment" }, "#ffffff")
-- vim.cmd(string.format([[highlight IndentBlanklineOOC guifg=%s gui=nocombine]], comment_color))

-- OOC = out of context, IC = in context
vim.cmd([[highlight IndentBlanklineOOC guifg=#46474A gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIC guifg=#F4C069 gui=nocombine]])

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
