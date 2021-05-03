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
local tsserver = require('lsp.efm.tsserver')
local sh = require('lsp.efm.sh')

local prettier = {
    formatCommand = "prettier_d_slim --stdin --stdin-filepath ${INPUT}",
    formatStdin = true
}

lspconfig.efm.setup {
    init_options = {documentFormatting = true},
    on_attach = on_attach,
    filetypes = {
        "lua", "python", "javascriptreact", "javascript", "typescript",
        "typescriptreact", "sh", "html", "css", "json", "yaml", "markdown",
        "vue"
    },
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = python,
            lua = lua,
            javascript = tsserver,
            javascriptreact = tsserver,
            typescript = tsserver,
            typescriptreact = tsserver,
            html = {prettier},
            css = {prettier},
            json = {prettier},
            yaml = {prettier},
            sh = sh
        }
    }
}

