require("lspconfig").rust_analyzer.setup({
	on_attach = function(client, bufnr)
		require("lsp").common_on_attach(client, bufnr)
		client.server_capabilities.documentFormattingProvider = true
	end,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				allFeatures = true,
				overrideCommand = {
					"cargo",
					"clippy",
					"--workspace",
					"--message-format=json",
					"--all-targets",
					"--all-features",
				},
			},
		},
	},
})
