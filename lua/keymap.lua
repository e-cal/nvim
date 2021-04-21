-- ================================ LEADER =====================================
-- unmap space and set it as the leader key
vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap=true, silent=true })
vim.g.mapleader = ' '

vim.api.nvim_set_keymap('n', '<Leader>e', ':Lexplore<CR>',
    { noremap=true, silent=true }
    )

-- ================================ GLOBAL =====================================

-- ================================ NORMAL =====================================

-- ================================ INSERT =====================================

-- ================================ VISUAL =====================================
