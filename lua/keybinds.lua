-- General keymaps

local map = vim.keymap.set

-- Buffer navigation
map("n", "<TAB>", function()
	vim.cmd("silent! w")
	vim.cmd("silent! e #")
end)

-- Scroll
map("n", "<C-y>", "3<C-y>")
map("n", "<C-e>", "3<C-e>")

-- Centering
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<C-S-o>", "<C-i>zz")

-- Quickfix
map("n", "<C-k>", "<cmd>cprev<cr>")
map("n", "<C-j>", "<cmd>cnext<cr>")

-- Auto set undo points on punctuation
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

-- Moving text
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

map("n", "gV", "`[v`]")

vim.g.mapleader = " "

-- map("n", "<leader>f", "<cmd>Format<cr>", { desc = "format" })
map("n", "<leader>n", "<cmd>NewFile<cr>", { desc = "new buffer" })
map("n", "<leader>ww", "<C-w>q", { desc = "close split" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "split horizontal" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "split vertical" })
map("n", "<leader>wj", "<C-w>J<C-w>k<C-w>H<C-w>l<C-w>j", { desc = "move under" })

map("v", "<leader>p", '"_dP', { desc = "paste no copy" })
map("v", "<leader>b", 'c**<C-r>"**<esc>', { desc = "bold" })
map("v", "<leader>i", 'c_<C-r>"_<esc>', { desc = "italic" })
map("v", "<leader>B", 'c**_<C-r>"_**<esc>', { desc = "bold & italic" })
map("v", "<leader>'", 'c"""<cr><C-r>""""<esc>', { desc = '"""' })
map("v", '<leader>"', 'c"""<cr><C-r>""""<esc>', { desc = '"""' })
map("v", "<leader>`", 'c```<cr><C-r>"```<esc>', { desc = "```" })

-- esc in terminal
map("t", "<esc><esc>", "<C-\\><C-n>", { nowait = true })
map("t", "<esc>", "<esc>")

-- nop(e)
map("n", "Q", "<NOP>")
map("n", ";", "<NOP>")
