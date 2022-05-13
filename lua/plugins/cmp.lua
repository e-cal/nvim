local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
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
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
	},
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "ultisnips" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "calc" },
		{ name = "cmp_tabnine" },
		{ name = "latex_symbols" },
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lua = "[LUA]",
				nvim_lsp = "[LSP]",
				path = "[PTH]",
				ultisnips = "[SNP]",
				buffer = "[BUF]",
				calc = "[CAL]",
				spell = "[SPL]",
				latex_symbols = "[LTX]",
				cmp_tabnine = "[TN]",
			})[entry.source.name]

			vim_item.kind = ({
				Text = "  Text",
				Method = "  Method",
				Function = "  Function",
				Constructor = "  Constructor",
				Field = "ﰠ  Field",
				Variable = "  Variable",
				Class = "ﴯ  Class",
				Interface = "  Interface",
				Module = "  Module",
				Property = "ﰠ  Property",
				Unit = "塞 Unit",
				Value = "  Value",
				Enum = "  Enum",
				Keyword = "  Keyword",
				Snippet = "﬌  Snippet",
				Color = "  Color",
				File = "  File",
				Reference = "  Reference",
				Folder = "  Folder",
				EnumMember = "  EnumMember",
				Constant = "  Constant",
				Struct = "פּ Struct",
				Event = "  Event",
				Operator = "  Operator",
				TypeParameter = "  TypeParam",
			})[vim_item.kind]

			if entry.source.name == "cmp_tabnine" then
				vim_item.kind = "  Tabnine"
			elseif entry.source.name == "calc" then
				vim_item.kind = "  Calc"
			end

			return vim_item
		end,
	},
	experimental = { native_menu = false, ghost_text = true },
})

cmp.setup.filetype("markdown", {
	sources = {
		{ name = "buffer", keyword_length = 3 },
		{ name = "spell", keyword_length = 3 },
		{ name = "latex_symbols" },
		{ name = "path" },
		{ name = "ultisnips" },
		{ name = "calc" },
		{ name = "cmp_tabnine" },
	},
})

-- TODO: only enable if connected to wifi
-- cmp.setup.cmdline(":", {
-- 	sources = cmp.config.sources({
-- 		{ name = "path" },
-- 	}, {
-- 		{ name = "cmdline" },
-- 	}),
-- })

vim.cmd("hi CmpItemAbbr guifg=foreground")
vim.cmd("hi CmpItemAbbrDepreceated guifg=error")
vim.cmd("hi CmpItemAbbrMatchFuzzy gui=italic guifg=foreground")
vim.cmd("hi CmpItemKind guifg=#C678DD") -- Boolean
vim.cmd("hi CmpItemMenu guifg=#928374") -- Comment
