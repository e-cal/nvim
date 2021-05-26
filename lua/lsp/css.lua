require'lspconfig'.cssls.setup {
    cmd = {
        "node", DATA_PATH ..
            "/lspinstall/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
        "--stdio"
    },
    settings = {css = {validate = false}, scss = {validate = false}},
    on_attach = require'lsp'.common_on_attach,
    filetypes = {'css', 'scss', 'less', 'sass'}
}
