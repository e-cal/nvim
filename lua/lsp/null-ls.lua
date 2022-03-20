local null_ls = require("null-ls")

null_ls.setup({
	cmd = { "nvim" },
	debounce = 250,
	debug = false,
	default_timeout = 5000,
	diagnostics_format = "[#{c}] #{m} (#{s})",
	fallback_severity = vim.diagnostic.severity.ERROR,
	log = { enable = true, level = "warn", use_console = "async" },
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> FormatOnSave
            augroup END
            ]])
		end
	end,
	on_init = nil,
	on_exit = nil,
	-- root_dir = u.root_pattern(".null-ls-root", "Makefile", ".git"),
	update_in_insert = false,
	sources = {
		-- Code Actions
		null_ls.builtins.code_actions.refactoring,

		-- Formatting
		-- python
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		-- lua
		null_ls.builtins.formatting.stylua,
		-- js/ts/css/md etc
		null_ls.builtins.formatting.prettier,
	},
})
