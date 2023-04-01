local _global = {
	{
		"BufWinEnter",
		"*",
		"setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t",
	},
	{
		"BufRead",
		"*",
		"setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t",
	},
	{
		"BufNewFile",
		"*",
		"setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions-=t",
	},
	{ "VimLeave", "*", "call system('xclip -o | xclip -selection c" },
	{ "BufReadPost,BufWritePost,BufEnter,TextChanged,TextChangedI", "*", "UpdateWinbarHighlight" },
}

if HighlightOnYank then
	local yank = {
		"TextYankPost",
		"*",
		"lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200})",
	}
	table.insert(_global, yank)
end

Utils.make_augroups({
	_global,
	_dashboard = {
		{
			"FileType",
			"dashboard",
			"setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= ",
		},
		{
			"FileType",
			"dashboard",
			"set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2",
		},
		{ "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
		{
			"FileType",
			"dashboard",
			'call timer_start(50, { tid -> execute("IndentBlanklineDisable")})',
		},
	},
	_markdown = {
		{
			"FileType",
			"markdown",
			"setlocal spell foldexpr=MarkdownFold() foldmethod=expr nofoldenable ts=2 sts=2 sw=2",
		},
		{ "FileType", "markdown", 'syntax match markdownIgnore "\\v\\w_\\w"' },
	},
	_python = {
		{ "FileType", "python", "setlocal indentkeys-=:" },
		{ "BufEnter", "*.py", "setlocal indentkeys-=<:>" },
	},
	_pddl = { { "BufEnter", "*.pddl", "setf pddl" } },
	_sql = {
		{ "FileType", "sql", "let formatOnSave=v:false" },
	},
})
