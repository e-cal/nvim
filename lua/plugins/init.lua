local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
end

-- Autocompile
vim.cmd 'autocmd BufWritePost init.lua PackerCompile'

return require('packer').startup(function(use)
    -- Package Manager
    use 'wbthomason/packer.nvim'
    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'glepnir/lspsaga.nvim'
    use 'kabouzeid/nvim-lspinstall'
    use 'hrsh7th/nvim-compe'
    use 'SirVer/ultisnips'
    -- Navigation
    use 'kyazdani42/nvim-tree.lua'
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'nvim-telescope/telescope-media-files.nvim'
    -- Convenience
    use 'folke/which-key.nvim'
    use 'windwp/nvim-autopairs'
    use 'terrortylor/nvim-comment'
    use 'kevinhwang91/nvim-bqf'
    use {'iamcco/markdown-preview.nvim', run = ':call mkdp#util#install()'}
    use 'norcalli/nvim-colorizer.lua'
    use 'lewis6991/gitsigns.nvim'
    use 'blackCauldron7/surround.nvim'
    use 'akinsho/nvim-toggleterm.lua'
    -- Debugging
    use 'mfussenegger/nvim-dap'
    -- Theming
    use 'kyazdani42/nvim-web-devicons'
    use 'glepnir/galaxyline.nvim'
    use 'romgrk/barbar.nvim'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'glepnir/dashboard-nvim'
    use {'ajmwagar/vim-deus', opt = true}
    use {'arcticicestudio/nord-vim', opt = true}
    use {'rakr/vim-two-firewatch', opt = true}
end)
