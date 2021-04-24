-- ================================ LEADER ====================================
-- unmap space and set it as the leader key
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap=true, silent=true })
vim.g.mapleader = ' '

-- save
vim.api.nvim_set_keymap('n', '<Leader>s', ':w<CR>', { noremap=true, silent=true })

-- quit
vim.api.nvim_set_keymap('n', '<Leader>q', ':qa<CR>', { noremap=true, silent=true })
-- close window
vim.api.nvim_set_keymap('n', '<Leader>w', ':q<CR>', { noremap=true, silent=true })
-- close buffer
vim.api.nvim_set_keymap('n', '<Leader>x', ':BufferClose<CR>', { noremap=true, silent=true })

-- file explorer
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap=true, silent=true })

-- ================================ GLOBAL ====================================

-- ================================ NORMAL ====================================

-- Split navigation
vim.api.nvim_set_keymap('n', '<M-h>', '<C-w>h', { silent=true })
vim.api.nvim_set_keymap('n', '<M-j>', '<C-w>j', { silent=true })
vim.api.nvim_set_keymap('n', '<M-k>', '<C-w>k', { silent=true })
vim.api.nvim_set_keymap('n', '<M-l>', '<C-w>l', { silent=true })

-- Buffer navigation
vim.api.nvim_set_keymap('n', '<C-T>', ':BufferNext<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<M-TAB>', ':bnext<CR>', { noremap=true, silent=true })

-- File navigation
vim.api.nvim_set_keymap('n', '<C-y>', '3<C-y>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<C-e>', '3<C-e>', { noremap=true, silent=true })

-- ================================ INSERT ====================================

-- ================================ VISUAL ====================================

-- Indenting
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap=true, silent=true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap=true, silent=true })

-- Move line
vim.api.nvim_set_keymap('v', 'K', ':m \'>-2<CR>gv-gv', { noremap=true, silent=true })

-- ================================ UNMAP =====================================
vim.api.nvim_set_keymap('n', 'Q', '<NOP>', { noremap=true, silent=true })
