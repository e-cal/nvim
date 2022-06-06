local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

-- ================================ NORMAL ====================================

-- Split navigation
map("n", "<M-h>", "<cmd>lua require('Navigator').left()<cr>", default_opts)
map("n", "<M-l>", "<cmd>lua require('Navigator').right()<cr>", default_opts)
map("n", "<M-k>", "<cmd>lua require('Navigator').up()<cr>", default_opts)
map("n", "<M-j>", "<cmd>lua require('Navigator').down()<cr>", default_opts)

-- Buffer navigation
map("n", "<C-T>", ":BufferNext<CR>", default_opts)
map("n", "<M-TAB>", ":BufferNext<CR>", default_opts)
map("n", "<S-TAB>", ":BufferPrev<CR>", default_opts)

-- Scroll
map("n", "<C-y>", "3<C-y>", default_opts)
map("n", "<C-e>", "3<C-e>", default_opts)

-- Resizing
map("n", "<C-Up>", ":resize +2<CR>", default_opts)
map("n", "<C-Down>", ":resize -2<CR>", default_opts)
map("n", "<C-Right>", ":vert resize +2<CR>", default_opts)
map("n", "<C-Left>", ":vert resize -2<CR>", default_opts)

-- LSP
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", default_opts)
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", default_opts)
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", default_opts)
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", default_opts)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", default_opts)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", default_opts)
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", default_opts)
map("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", default_opts)
map("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>", default_opts)

-- Stay centered when jumping around
map("n", "n", "nzzzv", default_opts)
map("n", "N", "Nzzzv", default_opts)
map("n", "J", "mzJ`z", default_opts)

-- H/L for beginning/end of line
map("n", "H", "^", default_opts)
map("v", "H", "^", default_opts)
map("n", "L", "$", default_opts)
map("v", "L", "$", default_opts)

-- Disable arrow keys
map("n", "<down>", "<nop>", default_opts)
map("n", "<up>", "<nop>", default_opts)
map("n", "<left>", "<nop>", default_opts)
map("n", "<right>", "<nop>", default_opts)
map("i", "<down>", "<nop>", default_opts)
map("i", "<up>", "<nop>", default_opts)
map("i", "<left>", "<nop>", default_opts)
map("i", "<right>", "<nop>", default_opts)

-- Save place on undo
map("n", "u", "muu", default_opts)

-- ================================ INSERT ====================================

-- Undo checkpoints
map("i", ",", ",<C-g>u", default_opts)
map("i", ".", ".<C-g>u", default_opts)
map("i", "!", "!<C-g>u", default_opts)
map("i", "?", "?<C-g>u", default_opts)

-- Fix tab
map("i", "^[[Z", "<S-Tab>", { noremap = true, silent = true, nowait = true })

-- ================================ VISUAL ====================================
-- Indenting
map("v", "<", "<gv", default_opts)
map("v", ">", ">gv", default_opts)

-- Move selection
map("v", "K", ":m '<-2<CR>gv=gv", default_opts)
map("v", "J", ":m '>+1<CR>gv=gv", default_opts)

-- ================================ UNMAP =====================================
map("n", "Q", "<NOP>", default_opts)
map("i", "<c-n>", "<NOP>", default_opts)
map("i", "<c-p>", "<NOP>", default_opts)
