return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	opts = function()
		local actions = require("diffview.config").actions
		local lib = require("diffview.lib")
		local fold_commands = {}
		for _, mapping in ipairs(actions.compat.fold_cmds) do
			fold_commands[mapping[2]] = mapping[3]
		end

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
					{ "n", "zO", fold_commands.zR, { desc = "expand all unchanged sections" } },
					{ "n", "zC", fold_commands.zM, { desc = "collapse all unchanged sections" } },
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
}
