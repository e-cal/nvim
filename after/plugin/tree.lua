local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")
local tree_cb = require("nvim-tree.config").nvim_tree_callback

local function collapse_all()
	require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function edit_or_open()
	-- open as vsplit on current node
	local action = "edit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
		view.close() -- Close the tree if file was opened
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
		view.close() -- Close the tree if file was opened
	end
end

function NvimTreeXdgOpen()
	local node = lib.get_node_at_cursor()
	if node then
		vim.fn.jobstart("xdg-open '" .. node.absolute_path .. "' &", { detach = true })
	end
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local config = {
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	view = {
		width = 30,
		side = "left",
		mappings = {
			custom_only = false,
			list = {
				{ key = "l", action = "edit", action_cb = edit_or_open },
				{ key = "h", action = "close_node" },
				{ key = "H", action = "collapse_all", action_cb = collapse_all },
				{ key = "o", cb = tree_cb("system_open") },
			},
		},
	},
	renderer = {
		icons = {
			glyphs = {
				default = "",
				symlink = " ",
				git = {
					unstaged = "",
					staged = "",
					unmerged = "",
					renamed = "➜",
					untracked = "ﱐ",
					deleted = "",
					ignored = "◌",
				},
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
			},
		},
	},
}

require("nvim-tree").setup(config)

-- Open in dir or empty buffer

local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	if not directory and not no_name then
		return
	end

	if directory then -- cd to the directory
		vim.cmd.cd(data.file)
	end

	-- open the tree
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
