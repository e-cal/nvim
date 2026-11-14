# e-cal/nvim

- [lazy.nvim](https://github.com/folke/lazy.nvim)
- all the things you expect and most likely want
- [whichkey](https://github.com/folke/which-key.nvim) to tell you what does what (leader: `<space>`)
- lots of cool stuff like
  - llms built in via [chat.nvim](https://github.com/e-cal/chat.nvim) and [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)
  - rendering images inline in markdown
  - repls and jupyter notebooks 
    - you can just `nvim notebook.ipynb`, then hit `<space>m` ([molten](https://github.com/benlubas/molten-nvim)/markdown) for relevant keybinds


<details>
  <summary>screenshots 👀</summary>
  
  ![image](https://github.com/user-attachments/assets/e6998091-abac-4fbb-a856-b4c12c5bbf4a)
  
  ![image](https://github.com/user-attachments/assets/8d25776f-fc6b-4ee4-b5be-137efd0448e8)
  
  ![image](https://github.com/user-attachments/assets/ab752443-f1f3-4d9a-9836-dafd8aed6cd8)

</details>



## Layout

| Path | Contents |
| --- | --- |
| `init.lua` | Entry point; loads the modules below in order |
| `vscode.lua` | Entry point for VS Code / Cursor (vscode-neovim); no plugins |
| `lua/config/options.lua` | Editor options and diagnostic signs |
| `lua/config/keymaps.lua` | Keymaps that need no plugin |
| `lua/config/autocmds.lua` | Autocommands and per-filetype settings |
| `lua/config/commands.lua` | User commands and command-line abbreviations |
| `lua/config/lsp.lua` | LSP keymaps and client defaults |
| `lua/config/highlights.lua` | Highlight overrides applied after the colorscheme |
| `lua/config/lazy.lua` | lazy.nvim bootstrap; imports every `lua/plugins/<area>/` |
| `lua/config/utils.lua` | Global `Utils` helpers and `P()` |
| `lua/plugins/<area>/<plugin>.lua` | lazy.nvim specs, named after the main plugin, with their options and keymaps |
| `lua/gumloop.lua` | Formatting and LSP overrides for buffers under `~/gumloop` |
| `lua/tools/` | Small built-in tools: IPython runner, rsync-on-save |
| `after/lsp/<server>.lua` | Per-server LSP settings |
| `snippets/` | LuaSnip snippets |

Plugin areas: `ai`, `editing`, `git`, `languages` (treesitter, markdown, notebooks, LaTeX), `lsp` (LSP, completion, formatting, diagnostics, debugging), `navigation` (pickers, file tree, motions, splits, quickfix), `ui`. Shared libraries are in `lua/plugins/libraries.lua`. `:Reload <plugin>` reruns a spec's config.
