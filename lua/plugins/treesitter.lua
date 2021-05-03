require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = {"haskell"},
    highlight = {enable = {enabled = true}},
    indent = {enable = true},
    autotag = {enable = true}
}
