local lsp = require("lsp-zero")
local cmp = require("cmp")

lsp.preset({
	name = "minimal",
	set_lsp_keymaps = false,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

-- Enable and configure language servers
local config = require("lspconfig")
config.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

require("lspconfig").pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = { enabled = false },
				pyflakes = { enabled = false },
				flake8 = {
					enabled = true,
					ignore = {
						"E203", -- whitespace before ':'
						"E302", -- expected 2 blank lines, found 1
						"E501", -- line too long
						"W504", -- line break after binary operator
					},
				},
			},
		},
	},
})

--

lsp.setup_nvim_cmp({
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 2 },
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
	formatting = {
		fields = { "abbr", "kind" },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "  ",
				path = "  ",
				luasnip = "↳  ",
				buffer = "  ",
				latex_symbols = "∑  ",
			})[entry.source.name]

			vim_item.kind = ({
				Text = " Text",
				Method = " Method",
				Function = " Function",
				Constructor = " Constructor",
				Field = "ﰠ Field",
				Variable = " Variable",
				Class = "ﴯ Class",
				Interface = " Interface",
				Module = " Module",
				Property = "ﰠ Property",
				Unit = "塞 Unit",
				Value = " Value",
				Enum = " Enum",
				Keyword = " Keyword",
				Snippet = "↳ Snippet",
				Color = " Color",
				File = " File",
				Reference = " Reference",
				Folder = " Folder",
				EnumMember = " EnumMember",
				Constant = " Constant",
				Struct = "פּ Struct",
				Event = " Event",
				Operator = " Operator",
				TypeParameter = " TypeParam",
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

local bg = require("lualine.utils.utils").extract_color_from_hllist("bg", { "ColorColumn" }, "#ff0000")
local function documentHighlight(client, bufnr)
	-- Set autocommands conditional on server_capabilities
	vim.api.nvim_exec(
		string.format(
			[[
                hi LspReferenceRead gui=bold ctermbg=red guibg=%s
                hi LspReferenceText gui=bold ctermbg=red guibg=%s
                hi LspReferenceWrite gui=bold ctermbg=red guibg=%s
            ]],
			bg,
			bg,
			bg
		),
		false
	)
	vim.api.nvim_exec(
		[[
            augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]],
		false
	)
end

lsp.on_attach(function(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		documentHighlight(client, bufnr)
	end
end)

lsp.setup()
