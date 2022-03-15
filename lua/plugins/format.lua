require("lsp-format").setup {
    lua = {
        {
            cmd = {
                function(file)
                    return string.format(
                        "luafmt -l %s -w replace %s",
                        vim.bo.textwidth,
                        file
                    )
                end
            }
        }
    },
    python = {
        {cmd = {"black --fast"}}
    },
    javascript = {
        {cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}}
    },
    typescript = {
        {cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}}
    },
    markdown = {
        {cmd = {"prettier -w"}}
    },
    java = {
        {
            cmd = {"google-java-format --replace"}
        }
    },
    vim = {
        {
            cmd = {"luafmt -w replace"},
            start_pattern = "^lua << EOF$",
            end_pattern = "^EOF$"
        }
    },
    vimwiki = {
        {
            cmd = {"prettier -w --parser babel"},
            start_pattern = "^{{{javascript$",
            end_pattern = "^}}}$"
        }
    }
}
