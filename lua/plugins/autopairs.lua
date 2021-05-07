require('nvim-autopairs').setup()

local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')

_G.MUtils = {}

vim.g.completion_confirm_key = ""
MUtils.completion_confirm = function()
    if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"](npairs.esc("<cr>"))
        else
            return npairs.esc("<cr>")
        end
    else
        return npairs.autopairs_cr()
    end
end

remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()',
      {expr = true, noremap = true})

local Rule = require('nvim-autopairs.rule')
npairs.add_rules({
    Rule(' ', ' '):with_pair(function(opts)
        local pair = opts.line:sub(opts.col, opts.col + 2)
        return vim.tbl_contains({'()', '[]', '{}'}, pair)
    end)
})

