return {
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
		return capabilities
	end)(),
	handlers = {
		-- ["textDocument/publishDiagnostics"] = function() end,
		["textDocument/hover"] = vim.lsp.with(Utils.custom_hover, {
			border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			max_width = 120,
			zindex = 500,
		}),
	},
	settings = {
    ty = {},
    -- pyright settings:
        -- useLibraryCodeForTypes = true,
        -- typeCheckingMode = "basic",
        -- diagnosticSeverityOverrides = {
        --         reportGeneralTypeIssues = "warning",
        --         reportUnusedVariable = "none",
        --         reportUndefinedVariable = "none",
        --         reportUnusedExpression = "none",
        --         reportWildcardImportFromLibrary = "none",
	},
}
