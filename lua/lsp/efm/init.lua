require "lsp.efm.handlers"
require "lsp.efm.formatting"
local lspconfig = require "lspconfig"

local on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp.efm.formatting'.format()]]
        vim.cmd [[augroup END]]
    end
end

-- Language specific efm configs
local python = require('lsp.efm.python')
local lua = require('lsp.efm.lua')

lspconfig.efm.setup {
    init_options = {documentFormatting = true},
    on_attach = on_attach,
    filetypes = {"python", "lua"}, -- Add new languages here
    settings = {
        rootMarkers = {".git/"},
        languages = {python = python, lua = lua} -- and here
    }
}

