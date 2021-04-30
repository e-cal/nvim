require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    highlight = {
        enable = {enabled = true}
    },
    indent = {enable = true},
    autotag = {
        enable = true,
        filetypes = {'html', 'xml', 'markdown'}
    },
}
