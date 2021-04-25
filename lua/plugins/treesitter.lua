require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = {enabled = true}
    },
    -- indent = {enable = true, disable = {"python", "html", "javascript"}},
    -- TODO seems to be broken
    -- indent = {enable = {"javascriptreact"}},
    indent = {enable = true},
    autotag = {enable = true},
}
