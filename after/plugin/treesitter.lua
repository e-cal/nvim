require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	ignore_install = { "haskell", "swift", "phpdoc" },
	highlight = {
		enable = true,
		disable = { "markdown" },
	},
	indent = {
		enable = true,
		disable = { "python" },
	},
	autotag = { enable = true },
})

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = "‾",
	zindex = 20, -- The Z-index of the context window
})

local ctx_bg = Utils.get_hl("Normal", "bg")
vim.cmd(string.format("hi TreesitterContext guibg=%s", ctx_bg))
local ctx_ln = Utils.get_hl("Cursor", "bg")
vim.cmd(string.format("hi TreesitterContextLineNumber guifg=%s", ctx_ln))
