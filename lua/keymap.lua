local map = vim.api.nvim_set_keymap

-- ================================ GLOBAL ====================================

-- ================================ NORMAL ====================================
-- Split navigation
map('n', '<M-h>', '<C-w>h', {silent = true})
map('n', '<M-j>', '<C-w>j', {silent = true})
map('n', '<M-k>', '<C-w>k', {silent = true})
map('n', '<M-l>', '<C-w>l', {silent = true})

-- Buffer navigation
map('n', '<C-T>', ':BufferNext<CR>', {noremap = true, silent = true})
map('n', '<M-TAB>', ':BufferNext<CR>', {noremap = true, silent = true})
map('n', '<S-TAB>', ':BufferPrev<CR>', {noremap = true, silent = true})

-- File navigation
map('n', '<C-y>', '3<C-y>', {noremap = true, silent = true})
map('n', '<C-e>', '3<C-e>', {noremap = true, silent = true})

-- Resizing
map('n', '<C-Up>', ':resize +2<CR>', {noremap = true, silent = true})
map('n', '<C-Down>', ':resize -2<CR>', {noremap = true, silent = true})
map('n', '<C-Right>', ':vert resize +2<CR>', {noremap = true, silent = true})
map('n', '<C-Left>', ':vert resize -2<CR>', {noremap = true, silent = true})

-- LSP
map('n', 'K', ':Lspsaga hover_doc<CR>', {noremap = true, silent = true})
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>',
    {noremap = true, silent = true})
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',
    {noremap = true, silent = true})
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>',
    {noremap = true, silent = true})
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
    {noremap = true, silent = true})
-- map('n', 'ca', ':Lspsaga code_action<CR>', { noremap=true, silent=true }) -- in whichkey
map('n', '<C-p>', ':Lspsaga diagnostic_jump_prev<CR>',
    {noremap = true, silent = true})
map('n', '<C-n>', ':Lspsaga diagnostic_jump_next<CR>',
    {noremap = true, silent = true})
-- scroll down hover doc or scroll in definition preview
map('n', '<Down>',
    '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(1)<CR>',
    {noremap = true, silent = true})
-- scroll up hover doc
map('n', '<Up>',
    '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(-1)<CR>',
    {noremap = true, silent = true})

-- Reindent paste
map('n', 'p', 'p`[v`[=', {noremap = true, silent = true})

-- Stay centered
map('n', 'n', 'nzzzv', {noremap = true, silent = true})
map('n', 'N', 'Nzzzv', {noremap = true, silent = true})
map('n', 'J', 'mzJ`z', {noremap = true, silent = true})

-- Arrows mess me up
map('n', '<down>', '<nop>', {noremap = true, silent = true})
map('n', '<up>', '<nop>', {noremap = true, silent = true})
map('n', '<left>', '<nop>', {noremap = true, silent = true})
map('n', '<right>', '<nop>', {noremap = true, silent = true})
map('i', '<down>', '<nop>', {noremap = true, silent = true})
map('i', '<up>', '<nop>', {noremap = true, silent = true})
map('i', '<left>', '<nop>', {noremap = true, silent = true})
map('i', '<right>', '<nop>', {noremap = true, silent = true})

-- 0 to first char (^)
map('n', '0', '^', {noremap = true, silent = true})

-- ================================ INSERT ====================================

-- Undo checkpoints
map('i', ',', ',<C-g>u', {noremap = true, silent = true})
map('i', '.', '.<C-g>u', {noremap = true, silent = true})
map('i', '!', '!<C-g>u', {noremap = true, silent = true})
map('i', '?', '?<C-g>u', {noremap = true, silent = true})

-- ================================ VISUAL ====================================
-- Indenting
map('v', '<', '<gv', {noremap = true, silent = true})
map('v', '>', '>gv', {noremap = true, silent = true})

-- Move selection
map('v', 'K', ":m '<-2<CR>gv=gv", {noremap = true, silent = true})
map('v', 'J', ":m '>+1<CR>gv=gv", {noremap = true, silent = true})

-- ================================ UNMAP =====================================
map('n', 'Q', '<NOP>', {noremap = true, silent = true})
