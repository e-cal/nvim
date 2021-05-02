Colorscheme = 'deus'

WrapLine = false
LineNumbers = true
RelativeLineNumbers = true
CursorLine = true
ColorColumn = 80
HighlightSearch = false -- Highlight all search matches
SearchIgnoreCase = true
AutoScroll = 8 -- Scroll when this many lines from top/bottom

TabSize = 4
UseSpaces = true

Term = {}
Term.shell = '/bin/fish'
Term.size = 10
Term.shade = true
Term.direction = 'horizontal' -- horizontal, vertical, window, or float
Term.floatBorder = 'shadow' -- single, double, shadow, or curved

-- Langage specific

Python = {}
Python.useKite = false
Python.autoFormat = true

Lua = {}
Lua.autoFormat = true

-- true: refresh on edit
-- false: refresh on save
MarkdownLiveRefresh = false

Font = "FiraCode Nerd Font:h17"

DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')
