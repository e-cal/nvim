require'lspconfig'.tsserver.setup {
    cmd = {
        DATA_PATH ..
            "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
        "--stdio"
    },
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescriptreact", "typescript.tsx"
    },
    on_attach = require'lsp'.tsserver_on_attach,
    root_dir = require('lspconfig/util').root_pattern("package.json",
                                                      "tsconfig.json",
                                                      "jsconfig.json", ".git"),
    settings = {documentFormatting = false},
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = true

            })
    }
}
