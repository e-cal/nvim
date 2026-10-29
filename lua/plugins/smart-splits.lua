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

local tern = {
	name = "tern",
	protocol_version = "3.0.0",
	detect = function()
		return vim.env.TERN_PANE ~= nil and vim.fn.executable("tern") == 1
	end,
}

local function tern_command(args)
	local result = vim.system(vim.list_extend({ "tern" }, args), { text = true, timeout = 1000 }):wait()
	return result.code == 0 and result.stdout or nil
end

-- Leaf rectangles of a `tern inspect` split tree in unit coordinates; a Row
-- split puts `a` left of `b`, a Column split puts `a` above `b`.
local function tern_leaves(node, rect, leaves)
	if node.Leaf then
		table.insert(leaves, { id = node.Leaf, x = rect.x, y = rect.y, w = rect.w, h = rect.h })
	elseif node.Split then
		local split, r = node.Split, node.Split.ratio
		if split.axis == "Row" then
			tern_leaves(split.a, { x = rect.x, y = rect.y, w = rect.w * r, h = rect.h }, leaves)
			tern_leaves(split.b, { x = rect.x + rect.w * r, y = rect.y, w = rect.w * (1 - r), h = rect.h }, leaves)
		else
			tern_leaves(split.a, { x = rect.x, y = rect.y, w = rect.w, h = rect.h * r }, leaves)
			tern_leaves(split.b, { x = rect.x, y = rect.y + rect.h * r, w = rect.w, h = rect.h * (1 - r) }, leaves)
		end
	end
	return leaves
end

-- The block sharing the most edge with this one in direction, as tmux picks.
local function tern_neighbor(direction)
	local ok, state = pcall(vim.json.decode, tern_command({ "inspect", "--json" }) or "")
	local pane = tonumber(vim.env.TERN_PANE)
	if not ok or not pane then
		return nil
	end
	for _, session in ipairs(state.sessions or {}) do
		for _, tab in ipairs(session.tabs or {}) do
			local leaves = tern_leaves(tab.splits or {}, { x = 0, y = 0, w = 1, h = 1 }, {})
			local current
			for _, leaf in ipairs(leaves) do
				if leaf.id == pane then
					current = leaf
				end
			end
			if current then
				if tab.zoomed then
					return nil
				end
				local horizontal = direction == "left" or direction == "right"
				local best, best_overlap = nil, 1e-6
				for _, leaf in ipairs(leaves) do
					local touches = ({
						left = leaf.x + leaf.w - current.x,
						right = current.x + current.w - leaf.x,
						up = leaf.y + leaf.h - current.y,
						down = current.y + current.h - leaf.y,
					})[direction]
					local overlap = horizontal
							and math.min(leaf.y + leaf.h, current.y + current.h) - math.max(leaf.y, current.y)
						or math.min(leaf.x + leaf.w, current.x + current.w) - math.max(leaf.x, current.x)
					if math.abs(touches) < 1e-6 and overlap > best_overlap then
						best, best_overlap = leaf.id, overlap
					end
				end
				return best
			end
		end
	end
end

tern.move = function(direction)
	local neighbor = tern_neighbor(direction)
	return neighbor ~= nil and tern_command({ "focus", string.format("%d", neighbor) }) ~= nil
end

-- The CLI has no resize command; `tern ctl` runs the keymap action in the
-- window showing this pane. Its reply can lag, so don't wait for it.
tern.resize = function(direction)
	vim.system({ "tern", "ctl", "plugins", "run", "resize_split:" .. direction })
	return true
end

return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	dependencies = {
		{ "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
	},
	opts = {
		mux = { backend = { "smart-splits-backend-tmux", rex, tern } },
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
