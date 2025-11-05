return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"kdheepak/cmp-latex-symbols",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		{
			"L3MON4D3/LuaSnip",
			config = function()
				require("luasnip.config").setup({ enable_autosnippets = true })
				require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets" } })

				local ls = require("luasnip")
				vim.keymap.set({ "i", "s" }, "<C-n>", function()
					ls.jump(1)
				end, { silent = true })
				vim.keymap.set({ "i", "s" }, "<C-k>", function()
					ls.jump(-1)
				end, { silent = true })
				vim.keymap.set({ "i", "s" }, "<C-N>", function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end, { silent = true })
			end,
		},
		"saadparwaiz1/cmp_luasnip",
	},
	event = "VeryLazy",
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			sources = {
				{ name = "parrot", priority = 100 },
				{ name = "path", priority = 100 },
				{ name = "latex_symbols", priority = 100 },
				{ name = "luasnip", priority = 95 },
				{ name = "copilot", priority = 90 },
				-- { name = "supermaven", priority = 90 },
				{ name = "nvim_lsp", priority = 80 },
				{ name = "nvim_lua", priority = 80 },
				{ name = "buffer", priority = 50, keyword_length = 3 },
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
				["<S-Tab>"] = cmp.mapping(function(fallback)
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
                ['<C-h>'] = cmp.mapping.abort(),
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
						Copilot = "󰚩 Copilot",
						Supermaven = "󰚩 Supermaven",
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
		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = Utils.get_hl("Conditional", "fg") })
		vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = Utils.get_hl("Conditional", "fg") })
	end,
}
