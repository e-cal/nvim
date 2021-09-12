local cmp = require('cmp')

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
    local col = vim.fn.col '.' - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
end

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
        end
    },

    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t("<C-n>"), "n")
            elseif check_back_space() then
                vim.fn.feedkeys(t("<tab>"), "n")
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-tab>"] = cmp.mapping(function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t("<C-p>"), "n")
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
        })
    },

    sources = {
        {name = 'buffer'}, {name = 'path'}, {name = 'calc'},
        {name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'ultisnips'}
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({nvim_lsp = '', buffer = ''})[entry.source
                                .name]
            vim_item.kind = ({
                Text = '  (Text)',
                Method = '  (Method)',
                Function = '  (Function)',
                Constructor = '  (Constructor)',
                Field = '  (Field)',
                Variable = '  (Variable)',
                Class = '  (Class)',
                Interface = 'ﰮ  (Interface)',
                Module = '  (Module)',
                Property = ' (Property)',
                Unit = '  (Unit)',
                Value = '  (Value)',
                Enum = '練  (Enum)',
                Keyword = '  (Keyword)',
                Snippet = '﬌  (Snippet)',
                Color = '  (Color)',
                File = '  (File)',
                Reference = '  (Reference)',
                Folder = '  (Folder)',
                EnumMember = '  (EnumMember)',
                Constant = 'ﲀ  (Constant)',
                Struct = '  (Struct)',
                Event = '  (Event)',
                Operator = '  (Operator)',
                TypeParameter = '  (TypeParam)',
                Calc = '  (Calc)'
            })[vim_item.kind]
            return vim_item
        end
    }
}

