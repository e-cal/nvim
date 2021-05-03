-- Variable settings defined in ../settings.lua
vim.cmd('syntax on') -- syntax highlighting
vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c') -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set inccommand=split') -- Make substitution work in realtime
vim.o.title = true
TERMINAL = vim.fn.expand('$TERMINAL')
vim.cmd('let &titleold="'..TERMINAL..'"')
vim.o.titlestring="%<%F%=%l/%L - nvim"

vim.o.showtabline=2               -- Always show buffer tabs
vim.o.hidden=true                     -- Allow multiple buffers to be open
vim.wo.wrap=WrapLine                      -- Don't wrap line
vim.wo.number=LineNumbers
vim.wo.relativenumber=RelativeLineNumbers
vim.o.cursorline=CursorLine                  -- Highlight current line
vim.o.splitbelow=true                  -- Hsplit below
vim.o.splitright=true                 -- Vsplit to the right
vim.cmd('set colorcolumn=' .. ColorColumn)
vim.o.hlsearch=HighlightSearch                  -- Don't highlight search matches
vim.o.ignorecase=SearchIgnoreCase                  -- Default case insensitive search
vim.o.smartcase=true                   -- Case sensitive if search has a capital letter
vim.o.mouse="a"                     -- Enable mouse
vim.o.scrolloff=AutoScroll                 -- Start scrolling before reaching the bottom

-- Use undofile instead of swap files for history
vim.o.swapfile=false
vim.o.backup=false
vim.o.undodir= os.getenv("HOME") .. "/.cache/nvim/undodir/"
vim.o.undofile=true

vim.cmd('set ts=' .. TabSize)
vim.cmd('set sw=' .. TabSize)
vim.o.expandtab=UseSpaces					-- Convert tabs to spaces
vim.o.smartindent=true                 -- Makes indenting smart
vim.o.autoindent=true                  -- Auto indent

vim.o.fileencoding="utf-8"          -- File encoding
vim.o.pumheight=10                -- Popup menu height
vim.o.cmdheight=1                 -- Space for cmd messages
vim.o.laststatus=2                -- Always display the status line
vim.o.conceallevel=0              -- Show `` in markdown files
vim.o.showmode=false                  -- Hide the editing mode
vim.o.writebackup=false               -- This is recommended by coc
vim.o.updatetime=300              -- Faster completion
vim.o.timeoutlen=500              -- By default timeoutlen is 1000 ms
vim.o.clipboard="unnamedplus"       -- Copy paste between vim and everything else
vim.wo.signcolumn="yes"

vim.o.guifont = Font

--vim.cmd('let g:python_highlight_space_errors = 0') -- Disable red whitespace in python
--vim.cmd('let g:polyglot_disabled = ['autoindent']') -- Disable polyglot autoindent
--vim.cmd('let g:vim_markdown_conceal_code_blocks = 0')
--autocmd BufNewFile,BufRead *.md filetype plugin indent off
--let g:python3_host_prog = '~/.local/share/virtualenvs/nvim/bin/python'

