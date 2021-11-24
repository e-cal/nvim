local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- ================================ GLOBAL ====================================

-- ================================ NORMAL ====================================
-- Split navigation
-- map("n", "<M-h>", "<C-w>h", {silent = true})
-- map("n", "<M-j>", "<C-w>j", {silent = true})
-- map("n", "<M-k>", "<C-w>k", {silent = true})
-- map("n", "<M-l>", "<C-w>l", {silent = true})

map("n", "<M-h>", "<cmd>lua require('Navigator').left()<cr>", opts)
map("n", "<M-l>", "<cmd>lua require('Navigator').right()<cr>", opts)
map("n", "<M-k>", "<cmd>lua require('Navigator').up()<cr>", opts)
map("n", "<M-j>", "<cmd>lua require('Navigator').down()<cr>", opts)

-- Buffer navigation
map("n", "<C-T>", ":BufferNext<CR>", opts)
map("n", "<M-TAB>", ":BufferNext<CR>", opts)
map("n", "<S-TAB>", ":BufferPrev<CR>", opts)

-- Scroll
map("n", "<C-y>", "3<C-y>", opts)
map("n", "<C-e>", "3<C-e>", opts)

-- Resizing
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Right>", ":vert resize +2<CR>", opts)
map("n", "<C-Left>", ":vert resize -2<CR>", opts)

-- LSP
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
map("n", "<C-p>", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
map("n", "<C-n>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)

-- Reindent paste
-- map('n', 'p', 'p`[v`[=', opts)

-- Stay centered
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "J", "mzJ`z", opts)

-- H and L for line jumping
map("n", "H", "^", opts)
map("n", "L", "$", opts)
map("v", "H", "^", opts)
map("v", "L", "$", opts)

-- Disable arrow keys
map("n", "<down>", "<nop>", opts)
map("n", "<up>", "<nop>", opts)
map("n", "<left>", "<nop>", opts)
map("n", "<right>", "<nop>", opts)
map("i", "<down>", "<nop>", opts)
map("i", "<up>", "<nop>", opts)
map("i", "<left>", "<nop>", opts)
map("i", "<right>", "<nop>", opts)

-- ================================ INSERT ====================================

-- Undo checkpoints
map("i", ",", ",<C-g>u", opts)
map("i", ".", ".<C-g>u", opts)
map("i", "!", "!<C-g>u", opts)
map("i", "?", "?<C-g>u", opts)

-- fix tab
map("i", "^[[Z", "<S-Tab>", {noremap = true, silent = true})

-- ================================ VISUAL ====================================
-- Indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move selection
map("v", "K", ":m '<-2<CR>gv=gv", opts)
map("v", "J", ":m '>+1<CR>gv=gv", opts)

-- ================================ UNMAP =====================================
map("n", "Q", "<NOP>", opts)
map("n", "Y", "Y", opts)
