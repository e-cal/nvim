local watchfiles = require("vim.lsp._watchfiles")

-- Cursor can create a self-referential `.cursor/.cursor` symlink in workspaces.
-- Excluding it keeps Neovim's LSP file watcher from stat'ing that loop on macOS.
local cursor_exclude = vim.glob.to_lpeg("**/.cursor/**")
if cursor_exclude then
	watchfiles._poll_exclude_pattern = watchfiles._poll_exclude_pattern + cursor_exclude
end

vim.lsp.config("*", {
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Remove Neovim's built-in LSP default keymaps that conflict with gr prefix
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grt")

local map = vim.keymap.set

local type_definition_preview = {
	buf = nil,
	win = nil,
	close_autocmd = nil,
	focusing = false,
}

local function close_type_definition_preview()
	if type_definition_preview.win and vim.api.nvim_win_is_valid(type_definition_preview.win) then
		vim.api.nvim_win_close(type_definition_preview.win, true)
	end
	if type_definition_preview.close_autocmd then
		pcall(vim.api.nvim_del_autocmd, type_definition_preview.close_autocmd)
	end
	type_definition_preview.buf = nil
	type_definition_preview.win = nil
	type_definition_preview.close_autocmd = nil
	type_definition_preview.focusing = false
end

local function preview_type_definition()
	if type_definition_preview.win and vim.api.nvim_win_is_valid(type_definition_preview.win) then
		type_definition_preview.focusing = true
		vim.api.nvim_set_current_win(type_definition_preview.win)
		return
	end

	local source_buf = vim.api.nvim_get_current_buf()
	local methods = { "textDocument/typeDefinition", "textDocument/definition" }
	local clients = vim.lsp.get_clients({ bufnr = source_buf })
	local offset_encoding = clients[1] and clients[1].offset_encoding or "utf-16"
	local params = vim.lsp.util.make_position_params(0, offset_encoding)

	local function request(method_index)
		local method = methods[method_index]
		if not method then
			vim.notify("No type definition available")
			return
		end

		vim.lsp.buf_request(source_buf, method, params, function(_, result, ctx)
			if not result or vim.tbl_isempty(result) then
				request(method_index + 1)
				return
			end

			local location = vim.tbl_islist(result) and result[1] or result
			local target_buf = vim.uri_to_bufnr(location.targetUri or location.uri)
			local range = location.targetSelectionRange or location.range
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			if not range or not client then
				return
			end

			vim.fn.bufload(target_buf)
			close_type_definition_preview()

			local width = math.floor(vim.o.columns * 0.8)
			local height = math.floor(vim.o.lines * 0.4)
			local row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1)
			local col = math.floor((vim.o.columns - width) / 2)
			local title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(target_buf), ":~:.")

			type_definition_preview.buf = target_buf
			type_definition_preview.win = vim.api.nvim_open_win(target_buf, false, {
				relative = "editor",
				row = row,
				col = col,
				width = width,
				height = height,
				style = "minimal",
				border = "rounded",
				focusable = true,
				title = title,
				title_pos = "center",
			})

			vim.api.nvim_win_set_cursor(type_definition_preview.win, {
				range.start.line + 1,
				vim.lsp.util._get_line_byte_from_position(target_buf, range.start, client.offset_encoding),
			})
			vim.api.nvim_win_call(type_definition_preview.win, function()
				vim.cmd("normal! zz")
			end)
			type_definition_preview.close_autocmd = vim.api.nvim_create_autocmd(
				{ "CursorMoved", "InsertEnter", "BufLeave" },
				{
					buffer = source_buf,
					once = true,
					callback = function()
						if type_definition_preview.focusing then
							return
						end
						if vim.api.nvim_get_current_win() ~= type_definition_preview.win then
							close_type_definition_preview()
						end
					end,
				}
			)
		end)
	end

	request(1)
end

-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
map("n", "<C-k>", preview_type_definition)
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "gk", "<cmd>lua vim.diagnostic.open_float()<CR>")
-- map("n", "<C-l>", "<cmd>lua vim.diagnostic.open_float()<CR>")
map("n", "<C-_>", function()
	vim.lsp.buf.workspace_symbol(vim.fn.expand("<cword>"))
end)

map("n", "<leader>ln", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>")
map("n", "<leader>lp", "<cmd>lua vim.diagnostic.jump( { count = -1, float = true })<CR>")
map("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "code actions" })
-- map("n", "<leader>ll", "<cmd>lua require('lint').try_lint()<cr>", { desc = "lint" })
map("n", "<leader>ll", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "buffer diagnostics" })
map("n", "<leader>lc", "<cmd>lua vim.diagnostic.reset()<cr>", { desc = "clear diagnostics" })
map("n", "<leader>lI", "mz<cmd>normal A  # type: ignore<cr>`z", { desc = "type: ignore" })
map("n", "<leader>ld", "<cmd>Trouble diagnostics<cr>", { desc = "diagnostics" })
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ timeout_ms=30000 })<cr>", { desc = "format" })
vim.keymap.set("n", "<leader>lF", function()
	vim.lsp.buf.code_action({
		filter = function(thing)
			return thing.title == "Ruff: Fix all auto-fixable problems"
		end,
		apply = true,
	})
end, { desc = "Fix auto-fixable problems" })
map("n", "<leader>lh", "<cmd>lua vim.lsp.buf.document_highlight()<cr>", { desc = "highlight symbol" })
map("n", "<leader>l?", "<cmd>LspInfo<cr>", { desc = "lsp info" })
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "rename" })
map("n", "<leader>lT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { desc = "type definition" })
map("n", "<leader>ls", function()
	vim.lsp.buf.workspace_symbol()
end, { desc = "document symbols" })
map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "workspace symbols" })
map("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "restart lsp" })
map("n", "<leader>lC", "<cmd>TSContextToggle<cr>", { desc = "toggle context" })
-- diagnostics
map("n", "<leader>lDa", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "all" })
map("n", "<leader>lDe", "<cmd>Telescope diagnostics bufnr=0 severity=error<cr>", { desc = "errors" })
map("n", "<leader>lDw", "<cmd>Telescope diagnostics bufnr=0 severity=warn<cr>", { desc = "warnings" })
map("n", "<leader>lDi", "<cmd>Telescope diagnostics bufnr=0 severity=info<cr>", { desc = "info" })
map("n", "<leader>lDh", "<cmd>Telescope diagnostics bufnr=0 severity=hint<cr>", { desc = "hint" })
-- workspace diagnostics
map("n", "<leader>lDWa", "<cmd>Telescope diagnostics<cr>", { desc = "all" })
map("n", "<leader>lDWe", "<cmd>Telescope diagnostics severity=error<cr>", { desc = "errors" })
map("n", "<leader>lDWw", "<cmd>Telescope diagnostics severity=warn<cr>", { desc = "warnings" })
map("n", "<leader>lDWi", "<cmd>Telescope diagnostics severity=info<cr>", { desc = "info" })
map("n", "<leader>lDWh", "<cmd>Telescope diagnostics severity=hint<cr>", { desc = "hint" })
-- workspace
map("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { desc = "add workspace" })
map("n", "<leader>lwd", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { desc = "remove workspace" })
map(
	"n",
	"<leader>lwl",
	"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
	{ desc = "list workspaces" }
)
