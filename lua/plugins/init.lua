local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

-- Autocompile
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

return require('packer').startup(function(use)
    -- Make packer manage itself
    use 'wbthomason/packer.nvim'

    -- Icons
    use 'kyazdani42/nvim-web-devicons'
    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use 'hrsh7th/vim-vsnip'
    -- Autocomlete
    use 'windwp/nvim-autopairs'
    use 'terrortylor/nvim-comment'
    -- Telescope
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    -- File explorer
    use 'kyazdani42/nvim-tree.lua'
    -- QuickFix
    use 'kevinhwang91/nvim-bqf'
    -- Statusline
    use 'glepnir/galaxyline.nvim'
    use 'romgrk/barbar.nvim'
    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'windwp/nvim-ts-autotag'
    -- Colorizer
    use 'norcalli/nvim-colorizer.lua'
    -- Theme
    use 'ajmwagar/vim-deus'
    -- Dashboard
    use 'glepnir/dashboard-nvim'
end)

