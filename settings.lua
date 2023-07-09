--[[
other general settings: lua/vim-settings.lua
plugin settings: after/plugin/<plugin>.lua
    ↳ refer to the plugin's github or :h plugin
]]
------------------------------ GENERAL SETTINGS -------------------------------
LeaderKey = " "

-- Colorschemes: deus, nord, two-firewatch, kanagawa, palenightfall, catppuccin
Colorscheme = "catppuccin"

SingleBuffer = true

WrapLine = false
LineNumbers = true
RelativeLineNumbers = true

FormatOnSave = false

HighlightCursorLine = true
ColorColumn = 80
IndentGuide = false -- sets if on by default (always toggleable with <leader>-i)
AutoScroll = 8 -- Scroll when this many lines from top/bottom (0 to disable)

HighlightAllSearchMatches = false
SearchIgnoreCase = true

TabSize = 4
UseSpaces = true

DATA_PATH = vim.fn.stdpath("data")
CACHE_PATH = vim.fn.stdpath("cache")

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
