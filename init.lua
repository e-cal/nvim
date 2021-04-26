require('globals')
require('plugins')
require('keymap')
require('settings')
require('functions')
require('auto')
require('colors')

-- LSP
require('lsp')
require('lsp.lua')

-- Plugin configs
vim.cmd('source ~/.config/nvim/lua/plugins/whichkey.vim')
require('plugins.autopairs')
require('plugins.colorizer')
require('plugins.comment')
require('plugins.compe')
require('plugins.galaxyline')
require('plugins.gitsigns')
require('plugins.telescope')
require('plugins.tree')
require('plugins.treesitter')


