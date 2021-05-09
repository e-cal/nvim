<h1>EVim</h1>

A VSCode-like editing experience in neovim. Sane default setup for a pleasant
drop-in editing experience, and logical configuration to support easy
customization.

Primarily uses lua-based plugins and configuration, with few exceptions,
along with native LSP for a blazingly fast editing experience.

**Requires neovim 0.5.0 or greater.**

<details>
<summary>Screenshots</summary>

![dashboard](https://user-images.githubusercontent.com/47398876/116168679-ff34f080-a6d0-11eb-918f-3d6db514d63b.png)

![VSCode Colors](https://user-images.githubusercontent.com/47398876/116168709-11169380-a6d1-11eb-94ed-824fcb3202a9.png)

![errors](https://user-images.githubusercontent.com/47398876/116168721-183da180-a6d1-11eb-9719-34d158643da0.png)

![full](https://user-images.githubusercontent.com/47398876/116168725-1a9ffb80-a6d1-11eb-8dbb-87189b425a1a.png)

![whichkey](https://user-images.githubusercontent.com/47398876/116168730-1bd12880-a6d1-11eb-903d-72639ed2d029.png)

</details>

Inspired by [LunarVim](https://github.com/ChristianChiarulli/LunarVim) and [ThePrimeagen](https://github.com/awesome-streamers/awesome-streamerrc/tree/master/ThePrimeagen)

---
<!-- [[toc]] -->
- [Installation](#install)
- [Features](#features)
- [Configuration](#config)
- [Default Keymap](#keys)
- [Colorschemes](#colors)
- [Plugins](#plugins)
---

## Installation <a name="install"></a>
1. Make sure the folder `~/.config/nvim` (or equivalent) doesn't already exist.
	- If you have an old config you don't want to lose:
	`mv ~/.config/nvim ~/.config/nvim.old`
2. Clone this repo: `git clone https://github.com/e-cal/evim ~/.config/nvim`
3. If you don't already have pynvim installed: `pip3 install pynvim`
4. Run `nvim` and do `:PackerInstall`
5. Update with `git fetch` + `git pull`
- For formatting install [efm-langserver](https://github.com/mattn/efm-langserver)
    - Seems to be broken when installed with `:LspInstall`
    - I recommend installing with `go get github.com/mattn/efm-langserver` or
    `brew install efm-langserver` or `pacman -S efm-langserver`
	- wsl2 requires some additional manual setup (environment variables)

## Features <a name="features"></a>
- Written and configured entirely in lua
- Native LSP
	- Completions, linting, formatting, snippets
    - Enable/disable auto-formatting for a filetype with `<leader>-l-F` or
	`:FormatToggle`
	- Easily add a language with `:LspInstall your-language`
	- Supports both [Kite](https://www.kite.com) and Pyright for python
    development
- Whichkey so you don't need to memorize all the keymappings
- Telescope and nvim-tree for seamless navigation
- Better terminal and floating terminals
- Git integration
    - Floating [lazygit](https://github.com/jesseduffield/lazygit) with
    `<leader>-g-l` (extremely useful for handling merge conflicts)
- Markdown previewing for docs and note-taking (powerful along with telescope
to search for text in notes)
	- Paste images from clipboard with `<leader>-p` or `:PasteImg`
- nvim-dap for debugging
- Improvement of life features: autopairs, strip end-of-line whitespace, better
quickfix, sane keymappings, undo edits from previous sessions, and more...
- Easily configurable and extensible - Make it your own!
    - Or checkout the `ecal` branch to use my preferred settings

## Configuration <a name="config"></a>
- General settings in `settings.lua`
- Add plugins in `lua/plugins/init.lua`
	- Install after adding with `:PackerSync`
	- `require` new configs in `init.lua`
- Non-leader keymappings are defined in `lua/keymap.lua`
- Leader keymappings

## Default Keymap <a name="keys"></a>
```
<space> - leader

<C-/> - comment lines (in a direction, <leader>-/ to comment current line)

<M-h> - focus left
<M-j> - focus down
<M-k> - focus up
<M-l> - focus right

<M-TAB> - next buffer

<C-Up> - increase up/down window size
<C-Down> - decrease up/down window size
<C-Right> - increase left/right window size
<C-Left> - decrease left/right window size

K - show hover docs
<C-k> - scroll up hover doc
<C-j> - scroll down hover doc

gd - go to definition
gD - go to declaration
gr - go to references
gi - go to implementation

<C-n> - jump to next diagnostic
<C-p> - jump to prev diagnostic
```
`<C-key>` = Control + key <br>
`<M-key>` = Alt + key

Press the leader key (space by default) to bring up whichkey help menu. <br>
If you can't find what you're looking for here, its probably in there
(or not implemented, in which case open an issue or PR).

## Colorschemes <a name="colors"></a>
You can try out the installed colorschemes with the keymap `<space>-t-c`. To
make the change permanent, change it in `settings.lua`.

Some themes may require some extra tweaking to get things looking the way you
want. The relevant files are `lua/colors.lua`, `lua/plugins/galaxyline.lua`
and `lua/plugins/barbar.lua`.

If you add and tweak a colorscheme, put in a PR!

## Plugins <a name="plugins"></a>
**Plugin manager**
- [packer](https://www.github.com/wbthomason/packer.nvim)

**LSP**
- [nvim-lspconfig](https://www.github.com/neovim/nvim-lspconfig)
- [lspsaga](https://www.github.com/glepnir/lspsaga.nvim)
- [nvim-lspinstall](https://www.github.com/kabouzeid/nvim-lspinstall)
- [nvim-compe](https://www.github.com/hrsh7th/nvim-compe)
- [ultisnips](https://www.github.com/SirVer/ultisnips)

**Navigation**
- [nvim-tree](https://www.github.com/kyazdani42/nvim-tree.lua)
- [popup (dependency)](https://www.github.com/nvim-lua/popup.nvim)
- [plenary (dependency)](https://www.github.com/nvim-lua/plenary.nvim)
- [telescope](https://www.github.com/nvim-telescope/telescope.nvim)
- [telescope-fzy-native](https://www.github.com/nvim-telescope/telescope-fzy-native.nvim)
- [telescope-media-files](https://www.github.com/nvim-telescope/telescope-media-files.nvim)

**Convenience**
- [which-key](https://www.github.com/folke/which-key.nvim)
- [nvim-autopairs](https://www.github.com/windwp/nvim-autopairs)
- [nvim-comment](https://www.github.com/terrortylor/nvim-comment)
- [nvim-bqf](https://www.github.com/kevinhwang91/nvim-bqf)
- [markdown-preview](https://www.github.com/iamcco/markdown-preview.nvim)
- [nvim-colorizer](https://www.github.com/norcalli/nvim-colorizer.lua)
- [gitsigns](https://www.github.com/lewis6991/gitsigns.nvim)
- [nvim-ts-autotag](https://www.github.com/windwp/nvim-ts-autotag)
- [surround](https://www.github.com/blackCauldron7/surround.nvim)
- [nvim-toggleterm](https://www.github.com/akinsho/nvim-toggleterm.lua)

**Debuging**
- [nvim-dap](https://www.github.com/mfussenegger/nvim-dap)
- [nvim-dap-ui](https://www.github.com/rcarriga/nvim-dap-ui)
- [nvim-dap-python](https://www.github.com/mfussenegger/nvim-dap-python)
- [sniprun](https://www.github.com/michaelb/sniprun)

**Theming**
- [nvim-web-devicons](https://www.github.com/kyazdani42/nvim-web-devicons)
- [galaxyline](https://www.github.com/glepnir/galaxyline.nvim)
- [barbar](https://www.github.com/romgrk/barbar.nvim)
- [nvim-treesitter](https://www.github.com/nvim-treesitter/nvim-treesitter)
- [dashboard-nvim](https://www.github.com/glepnir/dashboard-nvim)
- [vim-deus](https://www.github.com/ajmwagar/vim-deus)
- [nord-vim](https://www.github.com/arcticicestudio/nord-vim)
- [vim-two-firewatch](https://www.github.com/rakr/vim-two-firewatch)
