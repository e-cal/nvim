return {
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
		return capabilities
	end)(),
	handlers = {
		-- ["textDocument/publishDiagnostics"] = function() end,
		["textDocument/hover"] = function(err, result, ctx, config)
			return Utils.custom_hover(err, result, ctx, vim.tbl_extend("force", config or {}, {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				max_width = 120,
				zindex = 500,
			}))
		end,
	},
	settings = {
		python = {
			analysis = {
				useLibraryCodeForTypes = true,
				diagnosticSeverityOverrides = {
					reportGeneralTypeIssues = "warning",
					reportUnusedVariable = "none",
					reportUndefinedVariable = "none",
					reportUnusedExpression = "none",
					reportWildcardImportFromLibrary = "none",
				},
				typeCheckingMode = "basic",
			},
		},
	},
}
