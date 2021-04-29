vim.cmd('luafile ~/.config/nvim/settings.lua')
require('plugins')
require('keymap')
require('settings')
require('functions')
require('auto')
require('colors')

-- LSP
require('lsp')
require('lsp.lua')

if Python.useKite then
    require('lsp.kite')
else
    require('lsp.python')
end

-- Plugin configs
vim.cmd('source ~/.config/nvim/lua/plugins/whichkey.vim')
vim.cmd('source ~/.config/nvim/lua/plugins/markdown-preview.vim')
require('plugins.autopairs')
require('plugins.colorizer')
require('plugins.comment')
require('plugins.compe')
require('plugins.dashboard')
require('plugins.galaxyline')
require('plugins.gitsigns')
require('plugins.telescope')
require('plugins.tree')
require('plugins.treesitter')


