local api = vim.api

-- local formatters = {}

-- local python_autoformat = {'BufWritePre', '*.py', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
-- if Python.autoFormat then table.insert(formatters, python_autoformat) end

-- local lua_format = {'BufWritePre', '*.lua', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
-- if Lua.autoFormat then table.insert(formatters, lua_format) end

local function augroups(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command('augroup '..group_name)
		api.nvim_command('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
			api.nvim_command(command)
		end
		api.nvim_command('augroup END')
	end
end

augroups({
	_global = {
		{'BufWritePre', '*', ':call TrimWhitespace()'},
        {'BufWinEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufRead', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufNewFile', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'}
	},
    _dashboard = {
        {
            'FileType', 'dashboard',
            'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= '
        },
        {
            'FileType', 'dashboard',
            'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2'
        },
        {'FileType', 'dashboard', 'nnoremap <silent> <buffer> q :q<CR>'}
    },
    _markdown = {
        {'FileType', 'markdown', 'setlocal spell foldexpr=MarkdownLevel() foldmethod=expr nofoldenable'}
    },
    _python = {
        -- Don't mess up my indents
        {'FileType', 'python', 'setlocal indentkeys-=:'},
        {'BufEnter', '*.py', 'setlocal indentkeys-=<:>'},
    },
    -- _formatters = formatters
})
