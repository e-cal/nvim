-- Variable settings defined in ../settings.lua
vim.cmd("syntax on") -- syntax highlighting
vim.cmd("set iskeyword+=-") -- treat dash separated words as a word text object"
vim.cmd("set shortmess+=c") -- Don't pass messages to |ins-completion-menu|.
vim.cmd("set inccommand=split") -- Make substitution work in realtime
vim.cmd("set shell=/usr/bin/zsh") -- Use zsh as shell

vim.o.hidden = true -- allow keeping unsaved buffers open
vim.o.showtabline = 1

vim.wo.wrap = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.cursorline = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.colorcolumn = 80
vim.o.textwidth = 80
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"
vim.o.scrolloff = 8 -- Start scrolling before reaching the bottom

-- Use undofile instead of swap files for history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir/"
vim.o.undofile = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.autoindent = true
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

vim.g.python3_host_prog = vim.fn.exepath("python")
