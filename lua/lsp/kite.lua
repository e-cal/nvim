local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'
if not lspconfig.kite then
    configs.kite = {
        default_config = {
            cmd = {'~/.local/share/kite/current/kite-lsp'},
            filetypes = {'python'},
            root_dir = function(fname)
                return lspconfig.util.find_git_ancestor(fname) or
                           vim.loop.os_homedir()
            end,
            settings = {},
            on_attach = require'lsp'.common_on_attach
        }
    }
end

lspconfig.kite.setup {}
