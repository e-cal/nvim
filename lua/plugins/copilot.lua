local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

map("i", "<C-n>", "<Plug>(copilot-next)", default_opts)
map("i", "<C-p>", "<Plug>(copilot-previous)", default_opts)
map("i", "<C-x>", "<Plug>(copilot-dismiss)", default_opts)
