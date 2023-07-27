local cmp = require("cmp")
local config = require("lspconfig")
local masoncfg = require("mason-lspconfig")

-------------------------------------------------------------------------------
--                              Language servers
-------------------------------------------------------------------------------

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lsp_servers = {
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"gopls",
	"clangd",
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

-------------------------------------------------------------------------------
--                              cmp Setup
-------------------------------------------------------------------------------

cmp.setup({
	sources = {
		{ name = "jupynium" },
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip" },
		{ name = "latex_symbols" },
	},
	preselect = "none",
	completion = {
		completeopt = "menu,menuone,noinsert,noselect",
	},
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		fields = { "abbr", "kind" },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "󰣖  ",
				path = "󰉋  ",
				luasnip = "󱞩  ",
				buffer = "󰈙  ",
				latex_symbols = "󰒠  ",
			})[entry.source.name]

			vim_item.kind = ({
				Text = "󰉿 Text",
				Method = "󰆧 Method",
				Function = "󰊕 Function",
				Constructor = "󰒓 Constructor",
				Field = "󰜢 Field",
				Variable = "󰀫 Variable",
				Class = "󰠱 Class",
				Interface = "󰒪 Interface",
				Module = "󰏖 Module",
				Property = "󰜢 Property",
				Unit = "󰑭 Unit",
				Value = "󰎠 Value",
				Enum = "󰖽 Enum",
				Keyword = "󰌋 Keyword",
				Snippet = "󱞩 Snippet",
				Color = "󰏘 Color",
				File = "󰈙 File",
				Reference = "󰈇 Reference",
				Folder = "󰉋 Folder",
				EnumMember = "󰖽 EnumMember",
				Constant = "󰏿 Constant",
				Struct = "󰙅 Struct",
				Event = "󱐋 Event",
				Operator = "󰆕 Operator",
				TypeParameter = "󰊄 TypeParam",
			})[vim_item.kind]

			return vim_item
		end,
	},
})

-- Set diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-------------------------------------------------------------------------------
--                              Null-ls Setup (formatters)
-------------------------------------------------------------------------------

local null_ls = require("null-ls")
local u = require("null-ls.utils")

null_ls.setup({
	cmd = { "nvim" },
	debounce = 250,
	debug = false,
	default_timeout = 5000,
	diagnostics_format = "[#{c}] #{m} (#{s})",
	fallback_severity = vim.diagnostic.severity.ERROR,
	log = { enable = true, level = "warn", use_console = "async" },
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			-- tmp fix gq not working
			vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
			-- keep
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
	root_dir = u.root_pattern(".null-ls-root", "Makefile", ".git"),
	update_in_insert = false,
	-------------------------------------------------------------------------------
	-- Sources
	-- List of builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
	-------------------------------------------------------------------------------
	sources = {
		-- Code Actions
		null_ls.builtins.code_actions.refactoring,

		-- Formatting
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gofmt,

		null_ls.builtins.formatting.yapf.with({
			extra_args = { "--style", "{based_on_style: facebook, join_multiple_lines: true, column_limit: 85}" },
		}),

		null_ls.builtins.formatting.rustfmt.with({
			extra_args = function(params)
				local Path = require("plenary.path")
				local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

				if cargo_toml:exists() and cargo_toml:is_file() then
					for _, line in ipairs(cargo_toml:readlines()) do
						local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
						if edition then
							return { "--edition=" .. edition }
						end
					end
				end
				-- default edition when we don't find `Cargo.toml` or the `edition` in it.
				return { "--edition=2021" }
			end,
		}),

		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.shfmt,
	},
})
