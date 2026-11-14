return {
	"supermaven-inc/supermaven-nvim",
	enabled = false,
	opts = {
		disable_inline_completion = false,
		keymaps = {
			accept_suggestion = "<right>",
			clear_suggestion = "<C-k>",
			accept_word = "<C-j>",
			show_suggestion = "<C-l>",
		},
	},
	config = function(_, opts)
		require("supermaven-nvim").setup(opts)
		if opts.disable_inline_completion then
			local smvn = require("supermaven-nvim.completion_preview")
			local ns_id = vim.api.nvim_create_namespace("supermaven_custom")

			local function show_custom_suggestion()
				local buf = vim.api.nvim_get_current_buf()
				vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

				if not smvn.has_suggestion() then
					vim.notify("No suggestion available", vim.log.levels.INFO)
					return
				end

				local inlay_instance = smvn.inlay_instance
				if not inlay_instance or not inlay_instance.completion_text then
					vim.notify("No suggestion data found", vim.log.levels.INFO)
					return
				end

				local cursor = vim.api.nvim_win_get_cursor(0)
				local line = cursor[1] - 1
				local col = cursor[2]

				local completion_text = inlay_instance.completion_text
				local first_line = completion_text:match("^[^\n]*") or completion_text

				local _opts = {
					virt_text = { { first_line, "Comment" } },
					virt_text_pos = "eol", -- inline | eol
					hl_mode = "combine",
				}
				vim.api.nvim_buf_set_extmark(buf, ns_id, line, col, _opts)
				vim.b.supermaven_suggestion_shown = 1
				vim.notify("Suggestion displayed", vim.log.levels.INFO)
			end

			local function clear_custom_suggestion()
				local buf = vim.api.nvim_get_current_buf()
				vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
				vim.b.supermaven_suggestion_shown = 0
			end

			vim.keymap.set("i", opts.keymaps.show_suggestion, function()
				show_custom_suggestion()
			end, { noremap = true, silent = true })

			vim.keymap.set("i", opts.keymaps.clear_suggestion, function()
				clear_custom_suggestion()
				vim.notify("Suggestion cleared", vim.log.levels.INFO)
			end, { noremap = true, silent = true })

			vim.keymap.set("i", opts.keymaps.accept_suggestion, function()
				local svm = require("supermaven-nvim.completion_preview")
				if
					opts.disable_inline_completion
					or (not vim.b.supermaven_suggestion_shown or vim.b.supermaven_suggestion_shown == 0)
				then
					return vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes(opts.keymaps.accept_suggestion, true, false, true),
						"n",
						false
					)
				end
				svm.on_accept_suggestion(false)
				vim.b.supermaven_suggestion_shown = 0
				vim.notify("Suggestion accepted", vim.log.levels.INFO)
			end, { noremap = true, silent = true })

			vim.api.nvim_create_autocmd("TextChangedI", {
				group = vim.api.nvim_create_augroup("SupermavenClearSuggestion", { clear = true }),
				pattern = "*",
				callback = function()
					clear_custom_suggestion()
				end,
				desc = "Clear Supermaven suggestion on text change in insert mode",
			})

			vim.api.nvim_create_autocmd("ModeChanged", {
				group = vim.api.nvim_create_augroup("SupermavenClearSuggestion", { clear = false }),
				pattern = "i:*",
				callback = function()
					clear_custom_suggestion()
				end,
				desc = "Clear Supermaven suggestion on mode switch from insert mode",
			})
		end
	end,
}
