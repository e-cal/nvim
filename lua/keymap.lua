local map = vim.keymap.set

------------
-- Global --
------------

-- Buffer navigation
local swap = function()
	vim.cmd("silent! w")
	vim.cmd("silent! e #")
end
map("n", "<TAB>", swap)

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
-- Quickfix
map("n", "<C-k>", "<cmd>cprev<cr>")
map("n", "<C-j>", "<cmd>cnext<cr>")

-- Undo points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

-- Moving text
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

map("n", "Q", "<NOP>")
map("n", ";", "<NOP>")

-------------
-- Plugins --
-------------
if not vim.g.vscode then
	-- Split navigation
	map("n", "<M-h>", "<cmd>lua require('Navigator').left()<cr>")
	map("n", "<M-l>", "<cmd>lua require('Navigator').right()<cr>")
	map("n", "<M-k>", "<cmd>lua require('Navigator').up()<cr>")
	map("n", "<M-j>", "<cmd>lua require('Navigator').down()<cr>")
	map("n", "<M-TAB>", "<cmd>lua require('harpoon.ui').nav_next()<cr>")
	map("n", "<C-t>", "<cmd>silent! !toggleterm<cr>")

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
	map("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
	map("n", "<C-l>", "<cmd>lua vim.diagnostic.open_float()<CR>")

	map("n", "?", function()
		vim.lsp.buf.workspace_symbol(vim.fn.expand("<cword>"))
	end)

end
