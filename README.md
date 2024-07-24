# e-cal/nvim - the best nvim config

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



## Make it yours

- add/remove plugins with files in `plugins/`
  - return the `lazy` plugin spec
  - configuration & setup in the plugin spec (`mason` is the exception, configuration in `lsp.lua`)
  - _most_ plugins are in their own file
  - groups of plugins: `misc.lua`, `nav.lua`, `notebook.lua`, `theme.lua`
- plugin related keymaps defined in the plugin spec
- vanilla keymaps defined in `keymap.lua`
- `auto.lua` - auto commands
- `functions.lua` - user functions
- `settings.lua` - (n)vim settings
- `utils.lua` - useful lua functions
- `snippets/` - custom snippets
- `init.lua` - source any new top level files
