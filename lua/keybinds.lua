local map = vim.keymap.set

-- Buffer navigation
-- map("n", "<TAB>", function()
-- 	vim.cmd("silent! w")
-- 	vim.cmd("silent! e #")
-- end)

-- Scroll
map("n", "<C-y>", "3<C-y>")
map("n", "<C-e>", "3<C-e>")

-- Centering
map("n", "n", "nzzzv")
map("n", "gn", function()
	return vim.wo.diff and "]czz" or "gn"
end, { expr = true, desc = "next diff or select search match" })
map("n", "gp", function()
	return vim.wo.diff and "[czz" or "gp"
end, { expr = true, desc = "previous diff or paste" })
map("n", "zO", function()
	return vim.wo.diff and "zR" or "zO"
end, { expr = true, desc = "open all diff folds or current fold recursively" })
map("n", "zC", function()
	return vim.wo.diff and "zM" or "zC"
end, { expr = true, desc = "close all diff folds or current fold recursively" })
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")
map("n", "<C-S-o>", "<C-i>zz")

-- Quickfix
-- map("n", "<C-k>", "<cmd>cprev<cr>")
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
map("n", "<leader>w=", function()
	local preserved = {}
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			local buf = vim.api.nvim_win_get_buf(win)
			local buftype = vim.bo[buf].buftype
			local filetype = vim.bo[buf].filetype
			if (buftype ~= "" and buftype ~= "terminal") or filetype == "neo-tree" or filetype == "aerial" then
				preserved[win] = { width = vim.wo[win].winfixwidth, height = vim.wo[win].winfixheight }
				vim.wo[win].winfixwidth = true
				vim.wo[win].winfixheight = true
			end
		end
	end
	local ok, err = pcall(vim.cmd, "wincmd =")
	for win, options in pairs(preserved) do
		if vim.api.nvim_win_is_valid(win) then
			vim.wo[win].winfixwidth = options.width
			vim.wo[win].winfixheight = options.height
		end
	end
	if not ok then
		error(err)
	end
end, { desc = "balance editor splits" })

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
