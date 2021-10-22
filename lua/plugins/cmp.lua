local cmp = require('cmp')

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn['UltiSnips#Anon'](args.body)
        end
    },

    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
        })
    },

    sources = {
        {name = 'nvim_lua'}, {name = 'nvim_lsp'}, {name = 'path'},
        {name = 'ultisnips'}, {name = 'buffer', keyword_length = 4},
        {name = 'calc'}
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lua = '[LUA]',
                nvim_lsp = '[LSP]',
                path = '[PTH]',
                ultisnips = '[SNP]',
                buffer = '[BUF]',
                calc = '[CLC]',
                spell = '[SPL]',
                latex_symbols = '[LTX]'
            })[entry.source.name]

            vim_item.kind = ({
                Text = '  Text',
                Method = '  Method',
                Function = '  Function',
                Constructor = '  Constructor',
                Field = 'ﰠ  Field',
                Variable = '  Variable',
                Class = 'ﴯ  Class',
                Interface = '  Interface',
                Module = '  Module',
                Property = 'ﰠ  Property',
                Unit = '塞 Unit',
                Value = '  Value',
                Enum = '  Enum',
                Keyword = '  Keyword',
                Snippet = '﬌  Snippet',
                Color = '  Color',
                File = '  File',
                Reference = '  Reference',
                Folder = '  Folder',
                EnumMember = '  EnumMember',
                Constant = '  Constant',
                Struct = 'פּ Struct', -- there is something here I promise
                Event = '  Event',
                Operator = '  Operator',
                TypeParameter = '  TypeParam',
                Calc = '  Calc'
            })[vim_item.kind]
            return vim_item
        end
    },

    experimental = {native_menu = false, ghost_text = true}
}

vim.cmd('hi CmpItemAbbr guifg=foreground')
vim.cmd('hi CmpItemAbbrDepreceated guifg=error')
vim.cmd('hi CmpItemAbbrMatchFuzzy gui=italic guifg=foreground')
vim.cmd('hi CmpItemKind guifg=#C678DD') -- Boolean
vim.cmd('hi CmpItemMenu guifg=#928374') -- Comment
