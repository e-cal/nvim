local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
	-- Global options
	local opts = {
		on_attach = require("lsp").common_on_attach,
	}

	-- Language server specific
	if server.name == "tsserver" then
		opts.root_dir = require("lspconfig/util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
		-- Disable tsserver formatting
		opts.on_attach = function(client, bufnr)
			require("lsp").common_on_attach(client, bufnr)
			client.resolved_capabilities.document_formatting = false
		end
		opts.settings = { documentFormatting = false }
	end

	server:setup(opts)
end)

lsp_installer.settings({
	ui = {
		icons = {
			-- The list icon to use for installed servers.
			server_installed = "",
			-- The list icon to use for servers that are pending installation.
			server_pending = "",
			-- The list icon to use for servers that are not installed.
			server_uninstalled = "",
		},
		keymaps = {
			-- Keymap to expand a server in the UI
			toggle_server_expand = "<CR>",
			-- Keymap to install a server
			install_server = "i",
			-- Keymap to reinstall/update a server
			update_server = "u",
			-- Keymap to update all installed servers
			update_all_servers = "U",
			-- Keymap to uninstall a server
			uninstall_server = "d",
		},
	},

	-- The directory in which to install all servers.
	install_root_dir = DATA_PATH .. "/lsp_servers",

	pip = {
		-- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
		-- and is not recommended.
		--
		-- Example: { "--proxy", "https://proxyserver" }
		install_args = {},
	},

	-- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
	-- debugging issues with server installations.
	log_level = vim.log.levels.INFO,

	-- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
	-- servers that are requested to be installed will be put in a queue.
	max_concurrent_installers = 4,
})
