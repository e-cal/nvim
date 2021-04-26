<h1>EVim</h1>

A VSCode-like editing experience in neovim. Sane default setup for a pleasant
drop-in editing experience, and logical configuration to support easy
customization.

Primarily uses lua-based plugins and configuration, with few exceptions,
along with native LSP for a blazingly fast editing experience.

**Requires neovim 0.5.0 or greater.**

---
[[toc]]
---

## Installation
1. Make sure the folder `~/.config/nvim` (or equivalent) doesn't already exist.
	- If you have an old config you don't want to lose:
	`mv ~/.config/nvim ~/.config/nvim.old`
2. Clone this repo: `git clone https://github.com/e-cal/evim ~/.config/nvim`
3. If you don't already have pynvim installed: `pip3 install pynvim`
4. Run `nvim` and do `:PackerInstall`

## Features
- Almost entirely lua
- Native LSP
	- Completions, linting, formatting, snippets
	- Easily add a language with `:LspInstall your-language`
- Whichkey so you don't need to memorize all the keymappings
- Telescope and nvim-tree for seamless navigation
- nvim-dap for debugging
- Improvement of life features: autopairs, strip end-of-line whitespace, better
quickfix, sane keymappings, colorizer, and more...
- Easily configurable and extensible - Make it your own!

## Todo
Feel free to tackle something or submit a PR to add anything you think is
missing!
- [ ] finish documentation
- [ ] fix colors for firewatch scheme
- [x] customize dashboard
- [ ] fill out lsps
- [ ] add telescope extensions
- [ ] add snippets
- [ ] support terminal
- [ ] add floating lazygit
- [ ] guide for handling merge conflicts
- [ ] dap configuration
- [ ] add efm lsp
- [ ] support kite / tabnine

## Plugins
**Plugin manager**
- [packer](https://www.github.com/wbthomason/packer.nvim)

**LSP**
- [nvim-lspconfig](https://www.github.com/neovim/nvim-lspconfig)
- [lspsaga](https://www.github.com/glepnir/lspsaga.nvim)
- [nvim-lspinstall](https://www.github.com/kabouzeid/nvim-lspinstall)
- [nvim-compe](https://www.github.com/hrsh7th/nvim-compe)
- [vim-vsnip](https://www.github.com/hrsh7th/vim-vsnip)

**Navigation**
- [nvim-tree](https://www.github.com/kyazdani42/nvim-tree.lua)
- [popup (dependency)](https://www.github.com/nvim-lua/popup.nvim)
- [plenary (dependency)](https://www.github.com/nvim-lua/plenary.nvim)
- [telescope](https://www.github.com/nvim-telescope/telescope.nvim)
- [telescope-fzy-native](https://www.github.com/nvim-telescope/telescope-fzy-native.nvim)

**Improvement of life**
- [vim-which-key](https://www.github.com/liuchengxu/vim-which-key)
- [nvim-autopairs](https://www.github.com/windwp/nvim-autopairs)
- [nvim-comment](https://www.github.com/terrortylor/nvim-comment)
- [nvim-bqf](https://www.github.com/kevinhwang91/nvim-bqf)
- [markdown-preview](https://www.github.com/iamcco/markdown-preview.nvim)
- [nvim-colorizer](https://www.github.com/norcalli/nvim-colorizer.lua)
- [gitsigns](https://www.github.com/lewis6991/gitsigns.nvim)

**Debuging**
- [nvim-dap](https://www.github.com/mfussenegger/nvim-dap)

**Theming**
- [nvim-web-devicons](https://www.github.com/kyazdani42/nvim-web-devicons)
- [galaxyline](https://www.github.com/glepnir/galaxyline.nvim)
- [barbar](https://www.github.com/romgrk/barbar.nvim)
- [nvim-treesitter](https://www.github.com/nvim-treesitter/nvim-treesitter)
- [dashboard-nvim](https://www.github.com/glepnir/dashboard-nvim)
- [vim-deus](https://www.github.com/ajmwagar/vim-deus)
- [gruvbox-material](https://www.github.com/sainnhe/gruvbox-material)
- [nord-vim](https://www.github.com/arcticicestudio/nord-vim)
- [vim-two-firewatch](https://www.github.com/rakr/vim-two-firewatch)

## Default Keymap
```vim
<space> - leader
```
`<C-key>` = Control + key <br>
`<M-key>` = Alt + key

Press the leader key (space by default) to bring up whichkey help menu. <br>
If you can't find what you're looking for here, its probably in there
(or not implemented, in which case open an issue or PR).

## Colorschemes
You can try out the installed colorschemes with the keymap `<space>-t-c`. To
make the change permanent, change it in `settings.lua`.

Some themes may require some extra tweaking. The relevant files are
`lua/colors.lua`, `lua/plugins/galaxyline.lua` and `lua/plugins/barbar.lua`.

## Need Help?
- Check the plugin's readme or issues
- Check old issues (remove `is:open`)
- Check the help menu `:h thing-giving-me-problems`
- Or open an issue and I'll take a look!

---
Inspired by [LunarVim](https://github.com/ChristianChiarulli/LunarVim) and [ThePrimeagen](https://github.com/awesome-streamers/awesome-streamerrc/tree/master/ThePrimeagen)
