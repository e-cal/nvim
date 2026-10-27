local rex = {
	name = "rex",
	protocol_version = "3.0.0",
	detect = function()
		return vim.env.REX_SESSION ~= nil and vim.env.REX_BLOCK ~= nil
	end,
}

local function rex_command(args)
	local executable = vim.fn.exepath("rex")
	if executable == "" and vim.env.REX_BIN_DIR then
		executable = vim.env.REX_BIN_DIR .. "/rex"
	end
	if executable == "" or vim.fn.executable(executable) ~= 1 then
		return nil
	end
	local result = vim.system(vim.list_extend({ executable, "--timeout", "1s" }, args), { text = true }):wait()
	return result.code == 0 and result.stdout or nil
end

local function rex_focused_block()
	local output = rex_command({ "session", "inspect", vim.env.REX_SESSION, "--json" })
	local ok, view = pcall(vim.json.decode, output or "")
	if not ok then
		return nil
	end
	for _, window in ipairs(view.windows or {}) do
		if window.window_id == view.active_window_id and window.focused_block_id == vim.env.REX_BLOCK then
			for _, layer in ipairs(window.layers or {}) do
				for _, block in ipairs(layer.blocks or {}) do
					if block.block_id == vim.env.REX_BLOCK then
						return block
					end
				end
			end
		end
	end
end

rex.move = function(direction, opts)
	if not rex_focused_block() then
		return false
	end
	local args = { "focus", "-s", vim.env.REX_SESSION, direction }
	if opts and opts.at_edge == "wrap" then
		table.insert(args, "--wrap")
	end
	return rex_command(args) ~= nil
end

rex.resize = function(direction, opts)
	local block = rex_focused_block()
	if not block or not block.owner then
		return false
	end
	return rex_command({
		"-C",
		block.owner,
		"do",
		"pane.resize",
		"direction=" .. direction,
		"amount=" .. (opts.amount or 3),
	}) ~= nil
end

return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	dependencies = {
		{ "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
	},
	opts = {
		mux = { backend = { "smart-splits-backend-tmux", rex } },
	},
	keys = {
		{ "<M-h>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>", desc = "move left" },
		{ "<M-l>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>", desc = "move right" },
		{ "<M-k>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>", desc = "move up" },
		{ "<M-j>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>", desc = "move down" },
		{ "<M-H>", "<cmd>lua require('smart-splits').resize_left()<cr>", desc = "resize left" },
		{ "<M-J>", "<cmd>lua require('smart-splits').resize_down()<cr>", desc = "resize down" },
		{ "<M-K>", "<cmd>lua require('smart-splits').resize_up()<cr>", desc = "resize up" },
		{ "<M-L>", "<cmd>lua require('smart-splits').resize_right()<cr>", desc = "resize right" },
		{ "<M-C-h>", "<cmd>lua require('smart-splits').swap_buf_left()<cr>", desc = "swap left" },
		{ "<M-C-j>", "<cmd>lua require('smart-splits').swap_buf_down()<cr>", desc = "swap down" },
		{ "<M-C-k>", "<cmd>lua require('smart-splits').swap_buf_up()<cr>", desc = "swap up" },
		{ "<M-C-l>", "<cmd>lua require('smart-splits').swap_buf_right()<cr>", desc = "swap right" },
	},
}
