require("aerial").setup({
	filter_kind = false, -- show all
	-- {
	-- 	"Class",
	-- 	"Constructor",
	-- 	"Enum",
	-- 	"Function",
	-- 	"Interface",
	-- 	"Module",
	-- 	"Method",
	-- 	"Struct",
	-- },
    ------------------------------
    -- floating window settings --
    ------------------------------
	nav = {
		border = "rounded",
		max_height = 0.9,
		min_height = { 10, 0.1 },
		max_width = 0.5,
		min_width = { 0.2, 20 },
		win_opts = {
			cursorline = true,
			winblend = 10,
		},
		autojump = false,
        preview = true,
		-- Keymaps in the nav window
		keymaps = {
			["<CR>"] = "actions.jump",
			["<2-LeftMouse>"] = "actions.jump",
			["<C-v>"] = "actions.jump_vsplit",
			["<C-s>"] = "actions.jump_split",
			["h"] = "actions.left",
			["l"] = "actions.right",
			["<esc>"] = "actions.close",
		},
	},
    ------------------------------
    -- Sidebar --
    ------------------------------
	layout = {
		-- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
		max_width = { 40, 0.3 },
		width = 20,
		min_width = 10,
		default_direction = "left",
		placement = "window",
		preserve_equality = false,
	},
	close_automatic_events = { "unfocus" },
	keymaps = {
		["?"] = "actions.show_help",
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.jump",
		["<2-LeftMouse>"] = "actions.jump",
		["<C-v>"] = "actions.jump_vsplit",
		["<C-s>"] = "actions.jump_split",
		["<C-j>"] = "actions.down_and_scroll",
		["<C-k>"] = "actions.up_and_scroll",
		["{"] = "actions.prev",
		["}"] = "actions.next",
		["[["] = "actions.prev_up",
		["]]"] = "actions.next_up",
		["<esc>"] = "actions.close",
		["o"] = "actions.tree_toggle",
		["za"] = "actions.tree_toggle",
		["O"] = "actions.tree_toggle_recursive",
		["zA"] = "actions.tree_toggle_recursive",
		["l"] = "actions.tree_open",
		["L"] = {
			callback = function()
				require("aerial").tree_open()
				require("aerial").select({ jump = false })
			end,
		},
		["zo"] = "actions.tree_open",
		["zO"] = "actions.tree_open_recursive",
		["h"] = "actions.tree_close",
		["zc"] = "actions.tree_close",
		["H"] = "actions.tree_close_recursive",
		["zC"] = "actions.tree_close_recursive",
		["zr"] = "actions.tree_increase_fold_level",
		["zR"] = "actions.tree_open_all",
		["zm"] = "actions.tree_decrease_fold_level",
		["zM"] = "actions.tree_close_all",
		["zx"] = "actions.tree_sync_folds",
		["zX"] = "actions.tree_sync_folds",
	},
	highlight_closest = false,
	highlight_on_hover = false,
	highlight_on_jump = 500,
})
