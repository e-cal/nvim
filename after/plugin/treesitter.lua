require "nvim-treesitter.configs".setup {
    ensure_installed = "all",
    ignore_install = {"haskell", "swift", "phpdoc"},
    highlight = {
        enable = true,
        disable = {"markdown"}
    },
    indent = {
        enable = true,
        disable = {"python"}
    },
    autotag = {enable = true}
}
