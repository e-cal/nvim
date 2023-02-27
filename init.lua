dofile(os.getenv("HOME") .. "/.config/nvim/settings.lua")
require("utils")
require("plugins")
require("keymap")
require("vim-settings")
require("functions")
require("auto")
require("colors")

-- LSP
require("lsp")
