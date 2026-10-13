local staging_preview_ns = vim.api.nvim_create_namespace("staging_diff_preview")
local staging_previews = {}

local function clear_staging_preview(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, staging_preview_ns, 0, -1)
	staging_previews[bufnr] = nil
end

local function preview_staging_hunk(bufnr)
	local line = vim.api.nvim_win_get_cursor(0)[1]
	for _, hunk in ipairs(require("gitsigns").get_hunks(bufnr) or {}) do
		local first = math.max(1, hunk.added.start)
		local last = first + math.max(1, hunk.added.count) - 1
		if hunk.removed.count > 0 and line >= first and line <= last then
			local winid = vim.api.nvim_get_current_win()
			local width = vim.api.nvim_win_get_width(winid) - vim.fn.getwininfo(winid)[1].textoff
			local key = width .. hunk.head .. table.concat(hunk.lines, "\n")
			if staging_previews[bufnr] == key then
				return
			end
			clear_staging_preview(bufnr)
			local lines = {}
			local highlight = hunk.type == "delete" and "GitSignsDeleteVirtLn" or "RenderMarkdownH3Bg"
			for _, text in ipairs(hunk.lines) do
				if text:sub(1, 1) == "-" then
					local padding = string.rep(" ", math.max(0, width - vim.fn.strdisplaywidth(text)))
					lines[#lines + 1] = { { text .. padding, highlight } }
				end
			end
			vim.api.nvim_buf_set_extmark(bufnr, staging_preview_ns, first - 1, 0, {
				virt_lines = lines,
				virt_lines_above = hunk.added.count > 0 or hunk.added.start == 0,
			})
			staging_previews[bufnr] = key
			return
		end
	end
	clear_staging_preview(bufnr)
end

local staging_repos = {}
local staging_timer

local function sync_staging()
	for root, repo in pairs(staging_repos) do
		local active = false
		for bufnr in pairs(repo.buffers) do
			if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].staging_diff_enabled then
				active = true
			end
		end
		if active and not repo.fetching then
			repo.fetching = true
			vim.system(
				{ "git", "-C", root, "fetch", "--quiet", "origin", "refs/heads/staging:refs/remotes/origin/staging" },
				{
					timeout = 30000,
					env = { GIT_TERMINAL_PROMPT = "0" },
				},
				function(result)
					vim.schedule(function()
						repo.fetching = false
						if result.code ~= 0 then
							return
						end
						for bufnr in pairs(repo.buffers) do
							if vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].staging_diff_enabled then
								vim.api.nvim_buf_call(bufnr, function()
									require("gitsigns").change_base("origin/staging")
								end)
							end
						end
					end)
				end
			)
		end
	end
end

local function track_staging(bufnr)
	local root = vim.fn.system({ "git", "-C", vim.fn.expand("%:p:h"), "rev-parse", "--show-toplevel" })
	if vim.v.shell_error ~= 0 then
		return
	end
	root = vim.trim(root)
	staging_repos[root] = staging_repos[root] or { buffers = {} }
	staging_repos[root].buffers[bufnr] = true
	if not staging_timer then
		staging_timer = vim.uv.new_timer()
		staging_timer:start(300000, 300000, vim.schedule_wrap(sync_staging))
		vim.api.nvim_create_autocmd("VimLeavePre", {
			once = true,
			callback = function()
				staging_timer:stop()
				staging_timer:close()
			end,
		})
	end
end

return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			on_attach = function(bufnr)
				vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
					buffer = bufnr,
					desc = "Preview staging branch changes as virtual lines",
					callback = function(event)
						if event.event ~= "CursorMoved" or not vim.b[bufnr].staging_diff_enabled then
							clear_staging_preview(bufnr)
							return
						end
						preview_staging_hunk(bufnr)
					end,
				})
			end,
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
			{ "<leader>gd", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "preview hunk inline" },
			{
				"<leader>gD",
				function()
					local gs = require("gitsigns")
					local enabled = not vim.b.staging_diff_enabled
					if enabled then
						local ref
						for _, candidate in ipairs({ "origin/staging", "staging" }) do
							vim.fn.system({
								"git",
								"-C",
								vim.fn.expand("%:p:h"),
								"rev-parse",
								"--verify",
								candidate .. "^{commit}",
							})
							if vim.v.shell_error == 0 then
								ref = candidate
								break
							end
						end
						if not ref then
							vim.notify("No staging or origin/staging branch found", vim.log.levels.WARN)
							return
						end
						gs.change_base(ref)
					else
						clear_staging_preview(vim.api.nvim_get_current_buf())
						gs.reset_base()
					end
					vim.b.staging_diff_enabled = enabled
					gs.toggle_linehl(enabled)
					if enabled then
						track_staging(vim.api.nvim_get_current_buf())
					end
				end,
				desc = "toggle inline diff against staging branch",
			},
			{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "reset hunk" },
			{ "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "reset buffer" },
			{ "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", desc = "next hunk" },
			{ "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", desc = "prev hunk" },
			{ "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "blame" },
			{ "<leader>ga", "<cmd>Gitsigns stage_hunk<CR>", desc = "stage hunk (add/unadd)" },
		},
	},
	{
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
	},
}
