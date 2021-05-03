require "lsp.handlers"
require "lsp.formatting"
local lspconfig = require "lspconfig"

local on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua require'lsp.formatting'.format()]]
        vim.cmd [[augroup END]]
    end
end

lspconfig.efm.setup {
    init_options = {documentFormatting = true},
    on_attach = on_attach,
    filetypes = {"python"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {
                {
                    lintCommand = "flake8 --max-line-length 160 --stdin-display-name ${INPUT} -",
                    lintStdin = true,
                    lintIgnoreExitCode = true,
                    lintFormats = {"%f:%l:%c: %t%m"},
                    lintSource = "flake8",
                },
                {
                    formatCommand = "black --fast -",
                    formatStdin = true
                }
            },
        }
    }
}

