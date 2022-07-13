require("lspconfig").rust_analyzer.setup({
	on_attach = function(client, bufnr)
		require("lsp").common_on_attach(client, bufnr)
		client.server_capabilities.documentFormattingProvider = true
	end,
})
