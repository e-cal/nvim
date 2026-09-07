local project_markers = {
	".venv",
	"venv",
	"ty.toml",
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	".git",
}

-- Ty prefers VIRTUAL_ENV over a project's .venv. Strip the environment inherited
-- when Neovim starts so each LSP client resolves the virtualenv at its own root.
local ty_command = { "env", "-u", "VIRTUAL_ENV", "ty", "server" }

return {
	cmd = ty_command,
	root_markers = project_markers,
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
		return capabilities
	end)(),
	handlers = {
		-- ["textDocument/publishDiagnostics"] = function() end,
		["textDocument/hover"] = function(err, result, ctx, config)
			return Utils.custom_hover(
				err,
				result,
				ctx,
				vim.tbl_extend("force", config or {}, {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					max_width = 120,
					zindex = 500,
				})
			)
		end,
	},
	settings = {
		ty = {},
		-- pyright settings:
		-- useLibraryCodeForTypes = true,
		-- typeCheckingMode = "basic",
		-- diagnosticSeverityOverrides = {
		-- 	reportGeneralTypeIssues = "warning",
		-- 	reportUnusedVariable = "none",
		-- 	reportUndefinedVariable = "none",
		-- 	reportUnusedExpression = "none",
		-- 	reportWildcardImportFromLibrary = "none",
		-- },
	},
}
