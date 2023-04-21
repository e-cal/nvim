local wk = require("which-key")
wk.setup({
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = { ["<C-_>"] = "Comments" },
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "->", -- symbol used between a key and it's label
		group = "", -- symbol prepended to a group
	},
	window = {
		border = "shadow", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 0, 0, 0, 0 }, -- extra window margin [top, left, bottom, right]
		padding = { 1, 1, 1, 1 }, -- extra window padding [top, left, bottom, right]
	},
	layout = {
		height = { min = 4, max = 10 }, -- min and max height of the columns
		width = { min = 20, max = 300 }, -- min and max width of the columns
		spacing = 5, -- spacing between columns
	},
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers_blacklist = {
		i = { "^" },
	},
})

vim.g.mapleader = LeaderKey

-- Normal mode
local nmappings = {
	[" "] = "which_key_ignore",
	p = { "<cmd>Telescope find_files<cr>", "find files" },
	o = { "<cmd>OpenLast<cr>", "open last file" },
	["/"] = { "<cmd>CommentToggle<cr>", "toggle comment" },
	["?"] = { "<cmd>Neotree reveal<cr>", "find current file" },
	e = { "<cmd>Neotree toggle<cr>", "explorer" },
	b = { "m`<cmd>AerialToggle<cr>", "nav buffer" },
	B = { "m`<cmd>AerialNavToggle<cr>", "nav buffer (popup)" },
	N = { "<cmd>NnnExplorer<cr>", "nnn" },
	s = { "<cmd>w<cr>", "save" },
	q = { "<cmd>wqa<cr>", "save & quit" },
	Q = { "<cmd>qa!<cr>", "force quit" },
	w = { "<cmd>close<cr>", "close window" },
	x = { "<cmd>bd<cr>", "close buffer" },
	X = { "<cmd>bd!<cr>", "close buffer" },
	["."] = { "<cmd>luafile %<cr>", "source file" },
	v = { "<cmd>vert sp<cr>", "split right" },
	V = { "<cmd>sp<cr>", "split below" },
	n = { "<cmd>NewFile<cr>", "new buffer" },
	R = { "<cmd>e<cr>", "reload buffer" },
	i = { "<cmd>IndentBlanklineToggle<cr>", "toggle indent lines" },
	u = { "<cmd>UndotreeToggle<cr>", "toggle undo tree" },
	r = { ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", "rename" },
	-- Quick surround
	['"'] = { 'ciw"<C-r>""<esc>', '""' },
	["'"] = { "ciw'<C-r>\"'<esc>", "''" },
	["`"] = { 'ciw`<C-r>"`<esc>', "``" },
	-- Harpoon
	a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "add file" },
	h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "quick menu" },
	["+"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "which_key_ignore" },
	["["] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "which_key_ignore" },
	["{"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "which_key_ignore" },
	["("] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "which_key_ignore" },
	["&"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", "which_key_ignore" },
	["="] = { "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", "which_key_ignore" },
	[")"] = { "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", "which_key_ignore" },
	["}"] = { "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", "which_key_ignore" },
	["]"] = { "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", "which_key_ignore" },
	["*"] = { "<cmd>lua require('harpoon.ui').nav_file(10)<cr>", "which_key_ignore" },
	-- Menus
	d = {
		name = "debug",
		b = { "<cmd>DebugToggleBreakpoint<cr>", "toggle breakpoint" },
		c = { "<cmd>DebugContinue<cr>", "continue" },
		j = { "<cmd>DebugStepInto<cr>", "step into" },
		o = { "<cmd>DebugStepOver<cr>", "step over" },
		O = { "<cmd>DebugStepOut<cr>", "step out" },
		k = { "<cmd>DebugStepBack<cr>", "step back" },
		t = { "<cmd>DebugToggleUI<cr>", "toggle ui" },
		e = { "<cmd>DebugEvaluate<cr>", "evaluate" },
		l = { "<cmd>DebugListBreakpoints<cr>", "list breakpoints" },
		f = { "<cmd>DebugFloatElement<cr>", "float ui element" },
		p = {
			name = "python",
			m = { "<cmd>PythonTestMethod<cr>", "test method" },
			c = { "<cmd>PythonTestClass<cr>", "test class" },
		},
	},
	F = {
		name = "fold",
		O = { "<cmd>set foldlevel=20<cr>", "open all" },
		C = { "<cmd>set foldlevel=0<cr>", "close all" },
		c = { "<cmd>foldclose<cr>", "close" },
		o = { "<cmd>foldopen<cr>", "open" },
		["1"] = { "<cmd>set foldlevel=1<cr>", "level1" },
		["2"] = { "<cmd>set foldlevel=2<cr>", "level2" },
		["3"] = { "<cmd>set foldlevel=3<cr>", "level3" },
		["4"] = { "<cmd>set foldlevel=4<cr>", "level4" },
		["5"] = { "<cmd>set foldlevel=5<cr>", "level5" },
		["6"] = { "<cmd>set foldlevel=6<cr>", "level6" },
	},
	f = {
		name = "find",
		["."] = {
			"<cmd>TelescopeSearchDotfiles<cr>",
			"config",
		},
		["?"] = { "<cmd>Telescope filetypes<cr>", "filetypes" },
		g = { "<cmd>Telescope git_branches<cr>", "git branches" },
		b = { "<cmd>Telescope buffers<cr>", "buffers" },
		f = { "<cmd>Telescope find_files<cr>", "files" },
		h = { "<cmd>Telescope command_history<cr>", "cmd history" },
		i = { "<cmd>Telescope media_files<cr>", "media" },
		m = { "<cmd>Telescope marks<cr>", "marks" },
		M = { "<cmd>Telescope man_pages<cr>", "manuals" },
		o = { "<cmd>Telescope vim_options<cr>", "options" },
		t = {
			'<cmd>Telescope grep_string search="" only_sort_text=true<cr>',
			"text",
		},
		T = { "<cmd>Telescope live_grep<cr>", "exact text" },
		d = {
			"<cmd>TelescopeSearchDir<cr>",
			"search dir",
		},
		r = { "<cmd>Telescope oldfiles<cr>", "recents" },
		p = { "<cmd>Telescope registers<cr>", "registers" },
		e = { "<cmd>Telescope file_browser<cr>", "fuzzy explorer" },
		c = { "<cmd>Telescope colorscheme<cr>", "colorschemes" },
		q = { "<cmd>Telescope quickfix<cr>", "quickfix" },
		s = { "<cmd>Telescope aerial<cr>", "symbols" },
		n = { "<cmd>NnnPicker<cr>", "nnn" },
	},
	g = {
		name = "git",
		b = { "<cmd>Git blame_line<CR>", "blame" },
		d = { "<cmd>Git preview_hunk<cr>", "preview hunk diff" },
		w = { "<cmd>Git toggle_word_diff<CR>", "word diff" },
		D = { "<cmd>Git diffthis<CR>", "file diff" },
		n = { "<cmd>Git next_hunk<CR>", "next hunk" },
		p = { "<cmd>Git prev_hunk<CR>", "prev hunk" },
		r = { "<cmd>Git reset_hunk<CR>", "reset hunk" },
		R = { "<cmd>Git reset_buffer<CR>", "reset buffer" },
		a = { "<cmd>Git stage_hunk<CR>", "stage hunk" },
		A = { "<cmd>Git stage_buffer<cr>", "stage buffer" },
		u = { "<cmd>Git undo_stage_hunk<CR>", "undo stage hunk" },
		q = { "<cmd>Git setqflist<CR>", "quickfix" },
		g = { "<cmd>lua LazygitToggle()<CR>", "lazygit" },
	},
	l = {
		name = "lsp",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "code action" },
		l = { "<cmd>lua require('lint').try_lint()<cr>", "lint" },
		c = { "<cmd>lua vim.diagnostic.reset()<cr>", "clear diagnostics" },
		i = { "mz<cmd>normal A  # noqa<cr>`z", "pylsp ignore" },
		I = { "mz<cmd>normal A  # fmt: skip<cr>`z", "skip formatting" },
		d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "line" },
		D = {
			name = "diagnostics",
			a = { "<cmd>Telescope diagnostics bufnr=0<cr>", "all" },
			e = { "<cmd>Telescope diagnostics bufnr=0 severity=error<cr>", "errors" },
			w = { "<cmd>Telescope diagnostics bufnr=0 severity=warn<cr>", "warnings" },
			i = { "<cmd>Telescope diagnostics bufnr=0 severity=info<cr>", "info" },
			h = { "<cmd>Telescope diagnostics bufnr=0 severity=hint<cr>", "hint" },
			W = {
				name = "workspace diagnostics",
				a = { "<cmd>Telescope diagnostics<cr>", "all" },
				e = { "<cmd>Telescope diagnostics severity=error<cr>", "errors" },
				w = { "<cmd>Telescope diagnostics severity=warn<cr>", "warnings" },
				i = { "<cmd>Telescope diagnostics severity=info<cr>", "info" },
				h = { "<cmd>Telescope diagnostics severity=hint<cr>", "hint" },
			},
		},
		f = { "<cmd>lua vim.lsp.buf.format({ timeout_ms=30000 })<cr>", "format" },
		F = { "<cmd>FormatToggle<cr>", "toggle formatting" },
		h = { "<cmd>lua vim.lsp.buf.document_highlight()<cr>", "highlight symbol" },
		["?"] = { "<cmd>LspInfo<cr>", "lsp info" },
		v = { "<cmd>LspVirtualTextToggle<cr>", "toggle virtual text" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename" },
		T = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "type defintion" },
		x = { "<cmd>cclose<cr>", "close quickfix" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "document symbols" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "workspace symbols" },
		R = { "<cmd>LspRestart<cr>", "restart lsp" },
		C = { "<cmd>TSContextToggle<cr>", "toggle context" },
		w = {
			name = "workspace",
			a = {
				"<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
				"add workspace",
			},
			d = {
				"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
				"remove workspace",
			},
			l = {
				"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
				"list workspaces",
			},
		},
	},
	j = {
		name = "jupyter",
		r = { "<plug>JupyterExecute", "execute cell" },
		a = { "<plug>JupyterExecuteAll", "execute all cells" },
		R = { "<plug>JupterRestart", "restart kernel" },
	},
	m = {
		name = "markdown/tex",
		p = { "<cmd>PreviewDoc<cr>", "toggle preview" },
		i = { "<cmd>PasteImg<cr>2b", "paste image" },
		I = { "A  %_<esc>", "fix italics" },
		C = {
			"<cmd>s/\\(\\s[a-z]\\)\\|^\\([a-z]\\)/\\U\\2\\U\\1/g<CR>",
			"capitalize line",
		},
		s = { "1z=", "fix spelling" },
		c = { "mz<cmd>CleanText<cr>'z", "clean text" },
	},
	W = {
		name = "window",
		["<"] = { "<C-w><", "-x" },
		[">"] = { "<C-w>>", "+x" },
		["-"] = { "<C-w>-", "-y" },
		["+"] = { "<C-w>+", "+y" },
		["="] = { "<C-w>=", "reset window" },
		h = { "<cmd>split<cr>", "split horizontal" },
		v = { "<cmd>vsplit<cr>", "split vertical" },
		d = { "<cmd>close<cr>", "close split window" },
		j = { "<C-w>J", "move to bottom" },
		H = { "<C-w>J<C-w>k<C-w>H<C-w>l<C-w>j", "move under" },
	},
}

wk.register(nmappings, {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
})

-- Visual mode
local vmappings = {
	s = { "<cmd>Telescope grep_string<cr>", "search selection" },
	r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "rename" },
	p = { '"_dP', "paste no copy" },
	d = {
		name = "debug",
		e = { "<cmd>DebugEvaluate<cr>", "evaluate selected expression" },
		s = { "<cmd>PythonDebugSelection<cr>", "py debug selection" },
	},
	b = { 'c**<C-r>"**<esc>', "bold" },
	i = { 'c_<C-r>"_<esc>', "italic" },
	B = { 'c**_<C-r>"_**<esc>', "bold & italic" },
	m = { 'c$<C-r>"$<esc>', "inline math" },
	c = { 'c<span style="color: "><C-r>"</span><esc>T:a', "color" },
	l = { 'c[[./<C-r>"#<C-r>"|<C-r>"]]<esc>', "inlink" },
	a = { ':s/=/\\&=/g<cr>gvc\\begin{align}<cr><C-r>"<backspace><space>\\\\<cr>\\end{align}<esc>O&= ', "align" },
	g = {
		name = "format line",
		q = "format line length",
	},
}

wk.register(vmappings, {
	mode = "v",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
})
