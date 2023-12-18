local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "path",          priority = 100 },
        { name = "latex_symbols", priority = 100 },
        { name = "copilot",       priority = 90 },
        { name = "luasnip",       priority = 90 },
        { name = "nvim_lsp",      priority = 80 },
        { name = "nvim_lua",      priority = 80 },
        { name = "buffer",        priority = 50, keyword_length = 3 },
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
                Copilot = "󰚩 Copilot",
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

-- Copilot color
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = Utils.get_hl("Conditional", "fg") })
