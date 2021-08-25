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
            -- You must install `vim-vsnip` if you use the following as-is.
            vim.fn['UltiSnips#Anon'](args.body)
        end
    },

    completion = {completeopt = 'menu,menuone,noinsert'},

    -- You must set mapping if you want.
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
        -- ['<esc>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },

    -- You should specify your *installed* sources.
    sources = {
        {name = 'buffer'}, {name = 'path'}, {name = 'calc'},
        {name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'ultisnips'}

        --[[
        path = {kind = ""},
        buffer = {kind = ""},
        calc = {kind = ""},
        nvim_lsp = {kind = ""},
        nvim_lua = {kind = ""},
        spell = {kind = "", filetypes = {"markdown"}},
        ultisnips = {kind = ""},
        emoji = {kind = "ﲃ", filetypes = {"markdown"}}
]]
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({nvim_lsp = '', buffer = ''})[entry.source
                                .name]
            vim_item.kind = ({
                Text = '',
                Method = '',
                Function = '',
                Constructor = '',
                Field = '',
                Variable = '',
                Class = '',
                Interface = 'ﰮ',
                Module = '',
                Property = '',
                Unit = '',
                Value = '',
                Enum = '',
                Keyword = '',
                Snippet = '﬌',
                Color = '',
                File = '',
                Reference = '',
                Folder = '',
                EnumMember = '',
                Constant = '',
                Struct = '',
                Event = '',
                Operator = '',
                TypeParameter = '',
                Calc = ''
            })[vim_item.kind]
            return vim_item
        end
    }
}

-- vim.api.nvim_exec([[
-- autocmd FileType markdown lua require'cmp'.setup.buffer {
--    sources = {
--        { name = 'buffer' },
--        { name = 'nvim_lua' },
--        { name = 'spell' },
--    },
-- }]], false)

--[[
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = {kind = ""},
        buffer = {kind = ""},
        calc = {kind = ""},
        nvim_lsp = {kind = ""},
        nvim_lua = {kind = ""},
        spell = {kind = "", filetypes = {"markdown"}},
        ultisnips = {kind = ""},
        emoji = {kind = "ﲃ", filetypes = {"markdown"}}
    }
}

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
        -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
        --   return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
        -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        --   return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

vim.o.completeopt = "menuone,noselect"
]]
