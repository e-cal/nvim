------------------------------ GENERAL SETTINGS -------------------------------
Colorscheme = 'deus'
Font = 'FiraCode Nerd Font:h17'

WrapLine = false
LineNumbers = true
RelativeLineNumbers = true

CursorLine = true
ColorColumn = 80
AutoScroll = 8 -- Scroll when this many lines from top/bottom

HighlightSearch = false -- Highlight all search matches
SearchIgnoreCase = true
HighlightYank = false

TabSize = 4
UseSpaces = true

Term = {}
Term.shell = '/bin/fish' -- or a string with the path to a shell binary
Term.size = 10
Term.shade = true
Term.direction = 'horizontal' -- horizontal, vertical, window, or float
Term.floatBorder = 'shadow' -- single, double, shadow, or curved

DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')

-------------------------- LANGAGE SPECIFIC SETTINGS --------------------------
-- See lua/lsp/efm/<language>.lua to add formatters or linters
-- Add languages in lua/lsp/efm/init.lua

Python = {}
Python.useKite = false
Python.formatter = 'black'
Python.isort = false
Python.linter = nil -- add an additional linter for more coverage than pyright

Lua = {}
Lua.formatter = 'lua-format'
Lua.formatLineLength = 80

JS_TS = {}
JS_TS.formatter = 'prettier'
JS_TS.linter = 'eslint'

Shell = {}
Shell.formatter = 'shfmt'
Shell.linter = 'shellcheck'

Markdown = {}
Markdown.liveRefresh = false -- false: refresh on save
Markdown.imagePasteCommand = 'xclip -selection clipboard -t image/png -o > %s' -- Paste to file command
Markdown.imageDir = 'img' -- Sub-directory to save the image to
Markdown.imagePasteSyntax = 'obsidian' -- Image syntax to use (html, obsidian, or a format string)
Markdown.imageDefaultWidth = 600 -- Default width of images in px (or nil for no scaling)

-------------------------- DEBUGGER SETTINGS --------------------------
Debugger = {}
Debugger.pythonPath = '/usr/bin/python' -- path to python with debugpy installed
Debugger.useExternalTerminal = false
Debugger.externalTerminal = '/usr/bin/alacritty' -- path to terminal
