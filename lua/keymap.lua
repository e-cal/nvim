-- ================================ LEADER =====================================
-- unmap space and set it as the leader key
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap=true, silent=true })
vim.g.mapleader = ' '

-- quit
vim.api.nvim_set_keymap('n', '<Leader>q', ':qa<CR>', { noremap=true, silent=true })

-- file explorer
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap=true, silent=true })

-- ================================ GLOBAL =====================================

-- ================================ NORMAL =====================================

-- Split navigation
vim.api.nvim_set_keymap('n', '<M-h>', '<C-w>h', { silent=true })
vim.api.nvim_set_keymap('n', '<M-j>', '<C-w>j', { silent=true })
vim.api.nvim_set_keymap('n', '<M-k>', '<C-w>k', { silent=true })
vim.api.nvim_set_keymap('n', '<M-l>', '<C-w>l', { silent=true })

-- Buffer navigation
vim.api.nvim_set_keymap('n', '<C-T>', '<M-TAB>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<M-TAB>', ':bnext<CR>', { noremap=true, silent=true })


-- ================================ INSERT =====================================

-- ================================ VISUAL =====================================

-- Indenting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap=true, silent=true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap=true, silent=true })

-- Move line
vim.api.nvim_set_keymap('v', 'K', ':m \'>-2<CR>gv-gv', { noremap=true, silent=true })

