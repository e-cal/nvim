local api = vim.api

local function augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup ' .. group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end

local _global = {
    {'BufWritePre', '*', ':call TrimWhitespace()'}, {
        'BufWinEnter', '*',
        'setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t'
    }, {
        'BufRead', '*',
        'setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t'
    }, {
        'BufNewFile', '*',
        'setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t'
    }
}

if HighlightYank then
    local yank = {
        'TextYankPost', '*',
        'lua require(\'vim.highlight\').on_yank({higroup = \'Search\', timeout = 200})'
    }
    table.insert(_global, yank)
end

augroups({
    _global,
    _dashboard = {
        {
            'FileType', 'dashboard',
            'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= '
        }, {
            'FileType', 'dashboard',
            'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2'
        }, {'FileType', 'dashboard', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'dashboard', 'IndentBlanklineDisable'}
    },
    _markdown = {
        {
            'FileType', 'markdown',
            'setlocal spell foldexpr=MarkdownLevel() foldmethod=expr nofoldenable'
        }, {'FileType', 'markdown', 'syntax match markdownIgnore "\\v\\w_\\w"'}

    },
    _python = {
        -- Don't mess up my indents
        {'FileType', 'python', 'setlocal indentkeys-=:'},
        {'BufEnter', '*.py', 'setlocal indentkeys-=<:>'}
    }
})

local _store = {}
function _Create(f)
    table.insert(_store, f)
    return #_store
end

function _Execute(id, args)
    _store[id](args)
end

local function augroup_util(name, commands)
    vim.cmd("augroup " .. name)
    vim.cmd("autocmd!")
    for _, c in ipairs(commands) do
        local command = c.command
        if type(command) == "function" then
            local fn_id = _Create(command)
            command = string.format("lua _Execute(%s)", fn_id)
        end
        vim.cmd(string.format("autocmd %s %s %s %s",
                              table.concat(c.events, ","),
                              table.concat(c.targets or {}, ","),
                              table.concat(c.modifiers or {}, " "), command))
    end
    vim.cmd("augroup END")
end

local map = vim.api.nvim_buf_set_keymap

augroup_util("AddTerminalMappings", {
    {
        events = {"TermOpen"},
        targets = {"term://*"},
        command = function()
            if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
                local opts = {silent = false, noremap = true}
                map(0, "t", "<esc>", [[<C-\><C-n>]], opts)
                map(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
                map(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
                map(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
                map(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
            end
        end
    }
})
