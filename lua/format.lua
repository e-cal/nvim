local null_ls = require("null-ls")
local u = require("null-ls.utils")

null_ls.setup({
    cmd = { "nvim" },
    debounce = 250,
    debug = false,
    default_timeout = 5000,
    diagnostics_format = "[#{c}] #{m} (#{s})",
    fallback_severity = vim.diagnostic.severity.ERROR,
    log = { enable = true, level = "warn", use_console = "async" },
    on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
            -- tmp fix gq not working
            vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
            -- keep
            vim.cmd([[
	            augroup LspFormatting
	                autocmd! * <buffer>
	                autocmd BufWritePre <buffer> FormatOnSave
	            augroup END
	            ]])
        end
    end,
    on_init = nil,
    on_exit = nil,
    root_dir = u.root_pattern(".null-ls-root", "Makefile", ".git"),
    update_in_insert = false,
    -------------------------------------------------------------------------------
    -- Sources
    -- List of builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    -------------------------------------------------------------------------------
    sources = {
        -- Code Actions
        null_ls.builtins.code_actions.refactoring,

        -- Formatting
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.shfmt,

        null_ls.builtins.formatting.yapf.with({
            extra_args = {
                -- https://github.com/google/yapf#knobs
                "--style",
                "{ \
                    based_on_style: facebook, \
                    column_limit: 85, \
                    join_multiple_lines: true, \
                    indent_dictionary_value: false \
                    allow_split_before_default_or_named_assigns: false \
                    allow_split_before_dict_value: false \
                    coalesce_brackets: true \
                }",
            },
        }),

        null_ls.builtins.formatting.rustfmt.with({
            extra_args = function(params)
                local Path = require("plenary.path")
                local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

                if cargo_toml:exists() and cargo_toml:is_file() then
                    for _, line in ipairs(cargo_toml:readlines()) do
                        local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
                        if edition then
                            return { "--edition=" .. edition }
                        end
                    end
                end
                -- default edition when we don't find `Cargo.toml` or the `edition` in it.
                return { "--edition=2021" }
            end,
        }),

        null_ls.builtins.formatting.prettier.with({
            extra_args = { "--tab-width", "4" },
        }),
    },
})
