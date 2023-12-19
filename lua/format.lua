local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		python = { "yapf" },
	},
})

conform.formatters.yapf = {
	prepend_args = {
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
}

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
