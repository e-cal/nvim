local config = require("lspconfig")
local masoncfg = require("mason-lspconfig")

require("mason").setup()

masoncfg.setup({
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	ensure_installed = {
		"lua_ls",
		"pyright",
		"ruff_lsp",
		"clangd",
		"tsserver",
	},
})

local on_attach = function(client, bufnr) end

local custom_config = {
	lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim", "Utils", "s", "t", "i" } } } } },
	clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
	ruff_lsp = {
		init_options = {
			settings = {
				args = { "--select=F,W6,E71,E72,E112,E113,E203,E272,E702,E703,E731,W191,W291,W293,UP039,E999" },
			},
		},
		on_attach = function(client, bufnr)
			client.server_capabilities.hoverProvider = false
		end,
	},
	pyright = {
		capabilities = (function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
			return capabilities
		end)(),
		settings = {
			python = {
				analysis = {
					useLibraryCodeForTypes = true,
					diagnosticSeverityOverrides = {
						reportGeneralTypeIssues = "warning",
						reportUnusedVariable = "none",
						reportUndefinedVariable = "none",
					},
					typeCheckingMode = "basic",
				},
			},
		},
	},
}

masoncfg.setup_handlers({
	function(server_name)
		local server_config = {
			on_attach = on_attach,
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		}
		if custom_config[server_name] then
			server_config = vim.tbl_extend("force", server_config, custom_config[server_name])
		end
		config[server_name].setup(server_config)
	end,
})

--------------------------------------------------------------------------------
--                                 Formatting                                 --
--------------------------------------------------------------------------------
local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		python = { "yapf" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		markdown = { "prettier" },
	},
})

conform.formatters.yapf = {
	prepend_args = {
		"--style",
		"{ \
            based_on_style: facebook, \
            column_limit: 130, \
            join_multiple_lines: true, \
            indent_dictionary_value: false, \
            allow_split_before_default_or_named_assigns: false, \
            allow_split_before_dict_value: false, \
            coalesce_brackets: true, \
        }",
	},
}

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range }, function()
		vim.cmd("write")
	end)
end, { range = true })
