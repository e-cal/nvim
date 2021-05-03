local api = vim.api

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

local _global = {
    {'BufWritePre', '*', ':call TrimWhitespace()'},
    {'BufWinEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
    {'BufRead', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
    {'BufNewFile', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
}

if HighlightYank then
    local yank = {'TextYankPost', '*', 'lua require(\'vim.highlight\').on_yank({higroup = \'Search\', timeout = 200})'}
    table.insert(_global, yank)
end

augroups({
    _global,
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
})
