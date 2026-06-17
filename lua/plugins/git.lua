return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "_" },
				topdelete = { text = "▔" },
				changedelete = { text = "▎" },
				untracked = { text = "┆" },
			},
		},
		keys = {
			{ "<leader>gd", "<cmd>Git preview_hunk<cr>", desc = "preview hunk diff" },
			{ "<leader>gD", "<cmd>Git diffthis<CR>", desc = "file diff" },
			{ "<leader>gr", "<cmd>Git reset_hunk<CR>", desc = "reset hunk" },
			{ "<leader>gR", "<cmd>Git reset_buffer<CR>", desc = "reset buffer" },
			{ "<leader>gn", "<cmd>Git next_hunk<CR>", desc = "next hunk" },
			{ "<leader>gp", "<cmd>Git prev_hunk<CR>", desc = "prev hunk" },
			{ "<leader>gb", "<cmd>Git blame_line<CR>", desc = "blame" },
			{ "<leader>ga", "<cmd>Git stage_hunk<CR>", desc = "stage hunk (add/unadd)" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		opts = function()
			local actions = require("diffview.config").actions
			local lib = require("diffview.lib")

			function _G.diffview_q_abbrev()
				if vim.fn.getcmdtype() == ":" and vim.fn.getcmdline() == "q" and lib.get_current_view() then
					return "qa"
				end

				return "q"
			end

			vim.cmd([[cnoreabbrev <expr> q v:lua.diffview_q_abbrev()]])

			local function edit_file()
				local view = lib.get_current_view()
				local view_tab = vim.api.nvim_get_current_tabpage()

				actions.goto_file_edit()

				if view and vim.api.nvim_get_current_tabpage() ~= view_tab then
					vim.schedule(function()
						if view.tabpage and vim.api.nvim_tabpage_is_valid(view.tabpage) then
							view:close()
						end

						lib.dispose_view(view)
					end)
				end
			end

			return {
				hooks = {
					diff_buf_win_enter = function(bufnr, winid)
						if vim.api.nvim_buf_get_name(bufnr) ~= "diffview://null" then
							return
						end

						vim.defer_fn(function()
							if not vim.api.nvim_win_is_valid(winid) then
								return
							end

							local current_bufnr = vim.api.nvim_win_get_buf(winid)
							if vim.api.nvim_buf_get_name(current_bufnr) == "diffview://null" then
								pcall(vim.api.nvim_win_close, winid, true)
							end
						end, 100)
					end,
				},
				keymaps = {
					view = {
						{ "n", "q", edit_file, { desc = "edit file normally" } },
						{ "n", "ge", edit_file, { desc = "edit file normally" } },
						{ "n", "gq", "<cmd>DiffviewClose<cr>", { desc = "quit diff view" } },
						{ "n", "<leader>e", actions.toggle_files, { desc = "toggle file list" } },
						{ "n", "gF", actions.focus_files, { desc = "focus file list" } },
						{ "n", "gl", actions.cycle_layout, { desc = "cycle layout" } },
						{ "n", "[f", actions.select_prev_entry, { desc = "previous file" } },
						{ "n", "]f", actions.select_next_entry, { desc = "next file" } },
					},
					file_panel = {
						{ "n", "q", edit_file, { desc = "edit file normally" } },
						{ "n", "ge", edit_file, { desc = "edit file normally" } },
						{ "n", "gq", "<cmd>DiffviewClose<cr>", { desc = "quit diff view" } },
						{ "n", "<leader>e", actions.toggle_files, { desc = "toggle file list" } },
						{ "n", "gF", actions.focus_files, { desc = "focus file list" } },
						{ "n", "gl", actions.cycle_layout, { desc = "cycle layout" } },
						{ "n", "[f", actions.select_prev_entry, { desc = "previous file" } },
						{ "n", "]f", actions.select_next_entry, { desc = "next file" } },
						{ "n", "ga", actions.toggle_stage_entry, { desc = "git add / unadd file" } },
						{ "n", "gA", actions.stage_all, { desc = "git add all" } },
						{ "n", "gu", actions.toggle_stage_entry, { desc = "git unadd / add file" } },
						{ "n", "gU", actions.unstage_all, { desc = "git unadd all" } },
						{ "n", "gr", actions.refresh_files, { desc = "git refresh files" } },
						{ "n", "gt", actions.listing_style, { desc = "git tree/list toggle" } },
						{ "n", "gc", actions.open_commit_log, { desc = "git commit log" } },
					},
					file_history_panel = {
						{ "n", "q", edit_file, { desc = "edit file normally" } },
						{ "n", "ge", edit_file, { desc = "edit file normally" } },
						{ "n", "gq", "<cmd>DiffviewClose<cr>", { desc = "quit diff view" } },
						{ "n", "<leader>e", actions.toggle_files, { desc = "toggle file list" } },
						{ "n", "gF", actions.focus_files, { desc = "focus file list" } },
						{ "n", "gl", actions.cycle_layout, { desc = "cycle layout" } },
						{ "n", "[f", actions.select_prev_entry, { desc = "previous file" } },
						{ "n", "]f", actions.select_next_entry, { desc = "next file" } },
						{ "n", "gc", actions.open_commit_log, { desc = "git commit log" } },
					},
				},
			}
		end,
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "git diff view" },
			{ "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "open diff view" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "close diff view" },
			{ "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "file git history" },
		},
	},
}
