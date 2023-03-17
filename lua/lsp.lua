local lsp = require("lsp-zero")
local cmp = require("cmp")

lsp.preset({
	name = "minimal",
	set_lsp_keymaps = false,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

lsp.ensure_installed({
	"lua_ls",
	"pyright",
	"rust_analyzer",
})

lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

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

local bg = require("lualine.utils.utils").extract_color_from_hllist("bg", { "CursorLine" }, "#ff0000")
local function documentHighlight(client, bufnr)
	-- Set autocommands conditional on server_capabilities
	local enabled = vim.api.nvim_get_var("highlightSymbols")
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_exec(
			string.format(
				[[
                hi LspReferenceRead cterm=bold ctermbg=red guibg=%s
                hi LspReferenceText cterm=bold ctermbg=red guibg=%s
                hi LspReferenceWrite cterm=bold ctermbg=red guibg=%s
            ]],
				bg,
				bg,
				bg
			),
			false
		)
	end
	if enabled then
		vim.api.nvim_exec(
			[[
            augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]],
			false
		)
	end
end

lsp.on_attach(function(client, bufnr)
	documentHighlight(client, bufnr)
end)

lsp.setup()
