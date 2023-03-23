------------------------------ GENERAL SETTINGS -------------------------------
LeaderKey = " "

-- Colorschemes: deus, nord, two-firewatch, kanagawa, palenightfall, catppuccin
Colorscheme = "catppuccin"

WrapLine = false

LineNumbers = true
RelativeLineNumbers = true

HighlightCursorLine = true
ColorColumn = 80
IndentGuide = false -- enabled by default? (still toggleable with <leader>-I)
AutoScroll = 8 -- Scroll when this many lines from top/bottom (0 to disable)

HighlightAllSearchMatches = false
SearchIgnoreCase = true
HighlightOnYank = false

TabSize = 4
UseSpaces = true

FormatOnSave = true
AsyncFormatting = false -- WARNING: async formatting is less reliable - see https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Async-formatting
AlwaysTrimWhitespace = true -- trim whitespace even when formatting is disabled

DATA_PATH = vim.fn.stdpath("data")
CACHE_PATH = vim.fn.stdpath("cache")

-- other general settings: lua/vim-settings.lua
-- plugin settings: lua/plugins/<plugin>.lua
-- ↳ refer to the plugin's github (linked to in README.md) or :h plugin

-------------------------- LANGAGE SPECIFIC SETTINGS --------------------------
-- Most language specific behavior should be configured in lua/lsp/
-- See lua/lsp/null-ls.lua for formatting, code actions, and other language specific features

Markdown = {}
Markdown.previewLiveRefresh = false -- false = refresh on save
Markdown.imagePasteCommand = "xclip -selection clipboard -t image/png -o > %s" -- Paste to file command
Markdown.imageDir = "img" -- Sub-directory to save the image to
Markdown.imagePasteSyntax = "obsidian" -- Image syntax to use (html, obsidian, or a format string)
Markdown.imageDefaultWidth = 600 -- Default width of images in px (or nil for no scaling)

------------------------------ DEBUGGER SETTINGS ------------------------------
Debugger = {}
Debugger.pythonPath = "/usr/bin/python" -- path to python with debugpy installed
Debugger.useExternalTerminal = false
Debugger.externalTerminal = nil -- path to terminal
