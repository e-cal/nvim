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
		"gopls",
	},
})

local on_attach = function(client, bufnr) end

local custom_config = {
	lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim", "Utils", "s", "t", "i" } } } } },
	clangd = { cmd = { "clangd", "--offset-encoding=utf-16" } },
	ruff_lsp = {
		init_options = {
			settings = {
				args = {
					"--preview",
					"--select=F,W6,E71,E72,E112,E113,E203,E272,E702,E703,E731,W191,W291,W293,UP039,E999",
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
						-- reportUndefinedVariable = "none",
						reportUnusedExpression = "none",
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
map("n", "<leader>li", "mz<cmd>normal A  # type: ignore<cr>`z", { desc = "type: ignore" })
map("n", "<leader>lI", "mz<cmd>normal A  # yapf: disable<cr>`z", { desc = "skip formatting" })
map("n", "<leader>ld", "<cmd>TroubleToggle<cr>", { desc = "diagnostics" })
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
