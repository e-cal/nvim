local map = vim.keymap.set

-- ================================ NORMAL ====================================

-- Split navigation
map("n", "<M-h>", "<cmd>lua require('Navigator').left()<cr>")
map("n", "<M-l>", "<cmd>lua require('Navigator').right()<cr>")
map("n", "<M-k>", "<cmd>lua require('Navigator').up()<cr>")
map("n", "<M-j>", "<cmd>lua require('Navigator').down()<cr>")

-- Buffer navigation
map("n", "<M-TAB>", "<C-^>")

-- Scroll
map("n", "<C-y>", "3<C-y>")
map("n", "<C-e>", "3<C-e>")

-- Resizing
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Right>", ":vert resize +2<CR>")
map("n", "<C-Left>", ":vert resize -2<CR>")

-- LSP
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")

map("i", "<C-n>", "<Plug>(copilot-next)", { noremap = false })
map("i", "<C-p>", "<Plug>(copilot-previous)", { noremap = false })
map("i", "<C-x>", "<Plug>(copilot-dismiss)", { noremap = false })
map("i", "<C-f>", "<Plug>(copilot-suggest)", { noremap = false })

vim.g.copilot_no_tab_map = true
map("i", "<C-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true, replace_keycodes = false })

-- Stay centered when jumping around
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")

-- H/L for beginning/end of line
map("n", "H", "^")
map("v", "H", "^")
map("n", "L", "$")
map("v", "L", "$")

-- ================================ INSERT ====================================

-- Undo checkpoints
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

-- Fix tab
map("i", "^[[Z", "<S-Tab>", { noremap = true, silent = true, nowait = true })

-- ================================ VISUAL ====================================
-- Indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Move selection
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")

-- ================================ UNMAP =====================================
map("n", "Q", "<NOP>")
map("i", "<c-n>", "<NOP>")
map("i", "<c-p>", "<NOP>")
