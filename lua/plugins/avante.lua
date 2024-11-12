return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	build = "make",
	opts = {
		provider = "claude",
		claude = { api_key_name = "cmd:echo -n $(cat ~/.cache/anthropic)" },
		hints = { enabled = false },
		mappings = {
			ask = "<leader>ca",
			refresh = "<leader>cr",
			edit = "<leader>ce", -- edit selection
			diff = {
				ours = "co",
				theirs = "ct",
				none = "cq",
				both = "cb",
				next = "]x",
				prev = "[x",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-CR>",
			},
			toggle = {
				debug = "<leader>ad",
				hint = "<leader>ah",
			},
		},
	},
}
