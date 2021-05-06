vim.fn.sign_define("LspDiagnosticsSignError", {
    texthl = "LspDiagnosticsSignError",
    text = "",
    numhl = "LspDiagnosticsSignError"
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
    texthl = "LspDiagnosticsSignWarning",
    text = "",
    numhl = "LspDiagnosticsSignWarning"
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
    texthl = "LspDiagnosticsSignHint",
    text = "",
    numhl = "LspDiagnosticsSignHint"
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
    texthl = "LspDiagnosticsSignInformation",
    text = "",
    numhl = "LspDiagnosticsSignInformation"
})

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    "   (Text) ", "   (Method)", "   (Function)",
    "   (Constructor)", " ﴲ  (Field)", "[] (Variable)", "   (Class)",
    " ﰮ  (Interface)", "   (Module)", " 襁 (Property)", "   (Unit)",
    "   (Value)", " 練 (Enum)", "   (Keyword)", " ﬌  (Snippet)",
    "   (Color)", "   (File)", "   (Reference)", "   (Folder)",
    "   (EnumMember)", " ﲀ  (Constant)", " ﳤ  (Struct)", "   (Event)",
    "   (Operator)", "   (TypeParameter)"
}

local function documentHighlight(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
    end
end

local lsp_config = {}

function lsp_config.common_on_attach(client, bufnr)
    documentHighlight(client, bufnr)
end

function lsp_config.tsserver_on_attach(client, bufnr)
    lsp_config.common_on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
end

lsp_config.show_vtext = true

lsp_config.toggle_vtext = function()
    lsp_config.show_vtext = not lsp_config.show_vtext
    vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(0, 1), 0, 1,
                               {virtual_text = lsp_config.show_vtext})
end

vim.api.nvim_exec(
    'command! -nargs=0 LspVirtualTextToggle lua require("lsp").toggle_vtext()',
    false)

return lsp_config
