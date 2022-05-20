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
		if client.server_capabilities.documentFormattingProvider then
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
		-- List of builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md

		-- Code Actions
		null_ls.builtins.code_actions.refactoring,

		-- Formatting

		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.shfmt,
	},
})
