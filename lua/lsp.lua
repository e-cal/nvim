local config = require("lspconfig")
local masoncfg = require("mason-lspconfig")

config.clangd.setup({ cmd = { "clangd", "--offset-encoding=utf-16" } })

require("mason").setup()

masoncfg.setup({
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
	ensure_installed = {
		"lua_ls",
		"pyright",
		"ruff",
		"ts_ls",
		"gopls",
	},
})

local on_attach = function(client, bufnr) end

local mason_lsp_configs = {
	lua_ls = {
		settings = { Lua = { diagnostics = { globals = { "vim", "Utils", "P", "s", "t", "i", "fmt", "rep" } } } },
	},
	clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
	ruff = {
		init_options = {
			settings = {
				lineLength = 160,
				lint = {
					preview = true,
					select = {
						"F", -- pyflakes
						"W6", -- warnings
						"E1", -- indentation
						"E2", -- whitespace
                        "E501", -- line length
						"E71", -- value comparison
						"E72", -- type comparison & exceptions
						"E702", -- semicolons
						"E703", -- semicolons
						"E731", -- lambdas
						"W191", -- indentation
						-- "W291", -- trailing whitespace
						-- "W293", -- blank line whitespace
						"I002", -- missing import
						"UP039", -- unnecessary parens
						"PD", -- pandas
						"NPY", -- numpy
						"RUF", -- ruff specific
					},
					ignore = {
                        "E261", -- ignore whitespace before comments
						"F403", -- allow import *
						"F405", -- allow import from __future__
						"PD901", -- allow df as name
					},
				},
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
		handlers = {
			-- ["textDocument/publishDiagnostics"] = function() end,
			["textDocument/hover"] = vim.lsp.with(Utils.custom_hover, {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				max_width = 120,
				zindex = 500,
			}),
		},
		settings = {
			python = {
				analysis = {
					useLibraryCodeForTypes = true,
					diagnosticSeverityOverrides = {
						reportGeneralTypeIssues = "warning",
						-- reportUnusedVariable = "none",
						reportUndefinedVariable = "none",
						reportUnusedExpression = "none",
						reportWildcardImportFromLibrary = "none",
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
		if mason_lsp_configs[server_name] then
			server_config = vim.tbl_extend("force", server_config, mason_lsp_configs[server_name])
		end
		config[server_name].setup(server_config)
	end,
})

local map = vim.keymap.set
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map("n", "<C-l>", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "<C-_>", function()
	vim.lsp.buf.workspace_symbol(vim.fn.expand("<cword>"))
end)

map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code actions" })
map("n", "<leader>ll", "<cmd>lua require('lint').try_lint()<cr>", { desc = "lint" })
map("n", "<leader>lc", "<cmd>lua vim.diagnostic.reset()<cr>", { desc = "clear diagnostics" })
map("n", "<leader>lI", "mz<cmd>normal A  # type: ignore<cr>`z", { desc = "type: ignore" })
map("n", "<leader>ld", "<cmd>Trouble diagnostics<cr>", { desc = "diagnostics" })
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ timeout_ms=30000 })<cr>", { desc = "format" })
map("n", "<leader>lF", "<cmd>FormatToggle<cr>", { desc = "toggle formatting" })
map("n", "<leader>lh", "<cmd>lua vim.lsp.buf.document_highlight()<cr>", { desc = "highlight symbol" })
map("n", "<leader>l?", "<cmd>LspInfo<cr>", { desc = "lsp info" })
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "rename" })
map("n", "<leader>lT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "type definition" })
map("n", "<leader>ls", function()
	vim.lsp.buf.workspace_symbol()
end, { desc = "document symbols" })
map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "workspace symbols" })
map("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "restart lsp" })
map("n", "<leader>lC", "<cmd>TSContextToggle<cr>", { desc = "toggle context" })
-- diagnostics
map("n", "<leader>lDa", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "all" })
map("n", "<leader>lDe", "<cmd>Telescope diagnostics bufnr=0 severity=error<cr>", { desc = "errors" })
map("n", "<leader>lDw", "<cmd>Telescope diagnostics bufnr=0 severity=warn<cr>", { desc = "warnings" })
map("n", "<leader>lDi", "<cmd>Telescope diagnostics bufnr=0 severity=info<cr>", { desc = "info" })
map("n", "<leader>lDh", "<cmd>Telescope diagnostics bufnr=0 severity=hint<cr>", { desc = "hint" })
-- workspace diagnostics
map("n", "<leader>lDWa", "<cmd>Telescope diagnostics<cr>", { desc = "all" })
map("n", "<leader>lDWe", "<cmd>Telescope diagnostics severity=error<cr>", { desc = "errors" })
map("n", "<leader>lDWw", "<cmd>Telescope diagnostics severity=warn<cr>", { desc = "warnings" })
map("n", "<leader>lDWi", "<cmd>Telescope diagnostics severity=info<cr>", { desc = "info" })
map("n", "<leader>lDWh", "<cmd>Telescope diagnostics severity=hint<cr>", { desc = "hint" })
-- workspace
map("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { desc = "add workspace" })
map("n", "<leader>lwd", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { desc = "remove workspace" })
map(
	"n",
	"<leader>lwl",
	"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
	{ desc = "list workspaces" }
)
