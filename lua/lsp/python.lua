require'lspconfig'.pyright.setup {
    cmd = {
        DATA_PATH .. "/lspinstall/python/node_modules/.bin/pyright-langserver",
        "--stdio"
    },
    on_attach = require'lsp'.common_on_attach
}
