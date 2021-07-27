local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.cssls.setup {
    cmd = {"vscode-css-language-server", "--stdio"},
    settings = {
        css = {validate = false},
        scss = {validate = false},
        less = {validate = true}
    },
    on_attach = require'lsp'.common_on_attach,
    filetypes = {'css', 'scss', 'less', 'sass'},
    capabilities = capabilities
}
