-- Variable settings defined in ../settings.lua
vim.cmd("syntax on") -- syntax highlighting
vim.cmd("set iskeyword+=-") -- treat dash separated words as a word text object"
vim.cmd("set shortmess+=c") -- Don't pass messages to |ins-completion-menu|.
vim.cmd("set inccommand=split") -- Make substitution work in realtime
vim.cmd("set shell=/usr/bin/zsh") -- Use zsh as shell

vim.o.showtabline = 0 -- 2: Always show buffer tabs
vim.o.hidden = false -- Allow multiple buffers to be open
vim.wo.wrap = WrapLine -- Don't wrap line
vim.wo.number = LineNumbers
vim.wo.relativenumber = RelativeLineNumbers
vim.o.cursorline = HighlightCursorLine -- Highlight current line
vim.o.splitbelow = true -- Hsplit below
vim.o.splitright = true -- Vsplit to the right
vim.cmd("set colorcolumn=" .. ColorColumn)
vim.cmd("set textwidth=" .. ColorColumn)
vim.o.hlsearch = HighlightAllSearchMatches -- Don't highlight search matches
vim.o.ignorecase = SearchIgnoreCase -- Default case insensitive search
vim.o.smartcase = true -- Case sensitive if search has a capital letter
vim.o.mouse = "a" -- Enable mouse
vim.o.scrolloff = AutoScroll -- Start scrolling before reaching the bottom

-- Use undofile instead of swap files for history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir/"
vim.o.undofile = true

vim.cmd("set ts=" .. TabSize)
vim.cmd("set sts=" .. TabSize)
vim.cmd("set sw=" .. TabSize)
vim.o.expandtab = UseSpaces -- Convert tabs to spaces
vim.o.smartindent = true -- Makes indenting smart
vim.o.smarttab = true
vim.o.autoindent = true -- Auto indent
vim.cmd("filetype plugin indent on")

vim.o.fileencoding = "utf-8" -- File encoding
vim.o.pumheight = 10 -- Popup menu height
vim.o.cmdheight = 1 -- Space for cmd messages
vim.o.laststatus = 2 -- Always display the status line
vim.o.conceallevel = 0 -- Show `` in markdown files
vim.o.showmode = false -- Hide the editing mode
vim.o.writebackup = false -- This is recommended by coc
vim.o.updatetime = 300 -- Faster completion
vim.o.timeoutlen = 500 -- By default timeoutlen is 1000 ms
vim.o.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.wo.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.g.formatOnSave = FormatOnSave
