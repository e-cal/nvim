return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			python = { "yapf" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			json = { "prettier" },
			nix = { "nixfmt" },
		},

		formatters = {
			yapf = {
				prepend_args = {
					"--style",
					"{ \
                        based_on_style: facebook, \
                        column_limit: 115, \
                        join_multiple_lines: true, \
                        coalesce_brackets: true, \
                        indent_dictionary_value: false, \
                        allow_split_before_default_or_named_assigns: false, \
                        allow_split_before_dict_value: false, \
                        each_dict_entry_on_separate_line: false, \
                        split_before_logical_operator: true, \
                    }",
				},
			},
			prettier = {
				prepend_args = function()
					if vim.fn.expand("%:e") == "chat" then
						return { "--parser", "markdown" }
					end
				end,
			},
			injected = {
				options = {
					-- Set to true to ignore errors
					ignore_errors = true,
					-- Map of treesitter language to file extension
					-- A temporary file name with this extension will be generated during formatting
					-- because some formatters care about the filename.
					lang_to_ext = {
						bash = "sh",
						python = "py",
						latex = "tex",
						markdown = "md",
						rust = "rs",
						javascript = "js",
						typescript = "ts",
					},
				},
			},
		},
	},
	init = function()
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({ async = true, lsp_fallback = true, range = range }, function()
				vim.cmd("write")
			end)
		end, { range = true })
	end,
}
