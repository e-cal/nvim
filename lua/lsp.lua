local config = require("lspconfig")
local masoncfg = require("mason-lspconfig")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lsp_servers = {
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"gopls",
	"clangd",
	"astro",
	"tsserver",
}

require("mason").setup()
masoncfg.setup({ ensure_installed = lsp_servers })

-- set server settings
local settings = {
	lua_ls = {
		Lua = {
			diagnostics = {
				globals = { "vim", "Utils", "s", "t", "i" },
			},
		},
	},
}

-- override server cmd
local cmd = {
	clangd = {
		"clangd",
		"--offset-encoding=utf-16",
	},
}

local on_attach = function(client, bufnr) end

masoncfg.setup_handlers({
	function(server_name)
		local server_config = {
			on_attach = on_attach,
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		}

		if settings[server_name] then
			server_config["settings"] = settings[server_name]
		end
		if cmd[server_name] then
			server_config["cmd"] = cmd[server_name]
		end
		config[server_name].setup(server_config)
	end,
})

