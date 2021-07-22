-- Settings
vim.g.indent_blankline_enabled = false
vim.g.indent_blankline_use_treesitter = true

-- BACKGROUND HIGHLIGHTS
--[[
vim.cmd("highlight IndentOdd guifg=NONE guibg=NONE gui=nocombine")
vim.cmd("highlight IndentEven guifg=NONE guibg=#242A32 gui=nocombine")
vim.g.indent_blankline_char_highlight_list = {"IndentOdd", "IndentEven"}
vim.g.indent_blankline_space_char_highlight_list = {"IndentOdd", "IndentEven"}

vim.g.indent_blankline_char = " "
vim.g.indent_blankline_space_char = " "

vim.g.indent_blankline_show_trailing_blankline_indent = false
]] --
--
-- LINES
vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_space_char_blankline = " "
vim.g.indent_blankline_show_end_of_line = true
