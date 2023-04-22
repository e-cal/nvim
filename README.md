<h1>EVim</h1>

A VSCode-like editing experience in neovim. Sane default setup for a pleasant
drop-in editing experience, and logical configuration to support easy
customization.

Primarily uses lua-based plugins and configuration, with few exceptions,
along with native LSP for a blazingly fast editing experience.

**Requires neovim 0.5.0 or greater.**

<details>
<summary>Screenshots</summary>

> Outdated

![dashboard](https://user-images.githubusercontent.com/47398876/116168679-ff34f080-a6d0-11eb-918f-3d6db514d63b.png)

![VSCode Colors](https://user-images.githubusercontent.com/47398876/116168709-11169380-a6d1-11eb-94ed-824fcb3202a9.png)

![errors](https://user-images.githubusercontent.com/47398876/116168721-183da180-a6d1-11eb-9719-34d158643da0.png)

![full](https://user-images.githubusercontent.com/47398876/116168725-1a9ffb80-a6d1-11eb-8dbb-87189b425a1a.png)

![whichkey](https://user-images.githubusercontent.com/47398876/116168730-1bd12880-a6d1-11eb-903d-72639ed2d029.png)

</details>

> Inspired by [LunarVim](https://github.com/ChristianChiarulli/LunarVim) and [ThePrimeagen](https://github.com/ThePrimeagen/.dotfiles/tree/master/nvim/.config/nvim)

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
5. Update with `git fetch` + `git pull`, update plugins with `:PackerSync` (or `:PS` for short)

> Note: in order for symbols to display properly you need a patched font.
> Any font from [here](https://www.nerdfonts.com/font-downloads) will work.

## Features <a name="features"></a>

- Written and configured entirely in lua
- Native LSP
  - Completions, linting, formatting, snippets
  - Easily add LSP for a language with `:LspInstall`
  - Enable/disable auto-formatting with `<leader>-l-F` or `:FormatToggle` (change the default in `settings.lua`)
- Whichkey so you don't need to memorize all the keymappings
- Telescope, neo-tree, harpoon, and aerial for seamless navigation
- Git integration
- Markdown previewing for docs and note-taking (powerful along with telescope to search for text in notes)
  - Paste images from your clipboard with `<leader>-m-i` or `:PasteImg`
- Built in debugger
- Improvement of life features: autopairs, strip end-of-line whitespace, better
  quickfix, sane keymappings, tmux integration, and much more...
- Easily configurable and extensible - Make it your own!

## Configuration <a name="config"></a>

- General settings in `settings.lua`
- Regular keymappings are defined in `lua/keymap.lua`
- Leader-key keymappings in `plugins/whichkey.lua`
- Configure language servers with [Mason](https://github.com/williamboman/mason.nvim)
  - all LSP configuration in `lua/lsp.lua`
    ↳ i.e. language servers, cmp, formatters & other sources
- Add and remove plugins in `lua/plugins.lua`\
  ↳ install after adding with `:PS` or `:PackerSync`\
  ↳ configure plugins in `plugins/<plugin-name>.lua`\
  ↳ note that `plugins/` is actually a symlink to `after/plugin/`

> NOTE: I have disabled having multiple buffers open (in a single window) in favor of harpoon ala @ThePrimeagen <br>
> if you want to edit multiple buffers at a time and see the open tabs, change `SingleBuffer` to `false` in `settings.lua` <br>
> you may also want to install [bufferline](https://github.com/akinsho/bufferline.nvim) / [barbar](https://github.com/romgrk/barbar.nvim) / something similar to style it

## Default Keymap <a name="keys"></a>

```
<space> - leader

<leader>-/ - comment current line
<C-/> - comment multiple lines (takes a motion in normal mode, comments selected in visual)

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

> Press the leader key (space by default) to bring up whichkey help menu. <br>
> If you can't find what you're looking for here, its probably in there
> (or you can add it there yourself!).

## Colorschemes <a name="colors"></a>

You can try out the installed colorschemes with the keymap `<space>-f-c`. To
make the change permanent, change it in `settings.lua`.

Some themes may require some extra tweaking to get things looking the way you
want. The relevant files are `lua/colors.lua` and `plugins/barbar.lua`.

If you add and tweak a colorscheme, put in a PR!

## Plugins <a name="plugins"></a>

**Plugin manager**

- [packer](https://www.github.com/wbthomason/packer.nvim)

> This list changes often, so best to just look in `lua/plugins.lua`.
> Find the documentation for each at [https://www.github.com/\<author\>/\<plugin\>](#) <br>
> i.e. copy the string in `use` to fill the github link
