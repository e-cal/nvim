vim.cmd('luafile ~/.config/nvim/settings.lua')
require('plugins')
require('keymap')
require('vim-settings')
require('functions')
require('auto')
require('colors')

-- LSP
require('lsp')
require('lsp.bash')
require('lsp.efm')
require('lsp.latex')
require('lsp.lua')
require('lsp.vim')

if Python.useKite then
    require('lsp.kite')
else
    require('lsp.python')
end

-- Plugin configs
require('plugins.autopairs')
require('plugins.colorizer')
require('plugins.comment')
require('plugins.compe')
require('plugins.dashboard')
require('plugins.galaxyline')
require('plugins.gitsigns')
require('plugins.markdown-preview')
require('plugins.surround')
require('plugins.telescope')
require('plugins.toggleterm')
require('plugins.tree')
require('plugins.treesitter')
require('plugins.ultisnips')
require('plugins.whichkey')
