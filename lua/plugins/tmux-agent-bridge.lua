return {
	"e-cal/tmux-agent-bridge.nvim",
	dir = (function()
		local path = vim.fn.expand("~/projects/tmux-agent-bridge.nvim")
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
		return nil
	end)(),
	lazy = false,
	dependencies = {
		"rcarriga/nvim-notify",
	},
	opts = {
		ask = {
			capture = "buffer",
			buffer = {
				linewrap = true,
				submit_on_write = true,
				submit_keys = {
					n = { "<CR>" },
					i = { "<C-s>" },
				},
			},
		},
		watch = {
			notify = true,
			excluded_filetypes = {},
		},
		pane = {
			launch = {
				enabled = true,
				agent = "opencode",
				direction = "right",
				size = "40%",
				focus = false,
				allow_passthrough = false,
				auto_close = false,
				wait_ms = 1200,
			},
		},
		agents = {
			opencode = {
				detect = {
					title_patterns = { "^OC" },
					command_patterns = { "^opencode$" },
				},
				launch_cmd = "opencode",
				clear_keys = { "C-k" },
				new_keys = { "C-x", "n" },
				submit_keys = { "Enter" },
				display_title = function(pane)
					return pane.title:match("^OC | (.+)$") or pane.title
				end,
			},
		},
	},
	keys = {
		{
			"<leader>ac",
			function()
				require("tmux-agent-bridge").prompt(
					"Follow any instructions in the selected code and complete the functionality:\n\n@selection",
					{ submit = true }
				)
			end,
			mode = "x",
			desc = "Complete",
		},
		{
			"<leader>aa",
			function()
				require("tmux-agent-bridge").ask("@selection", { submit = true })
			end,
			mode = "x",
			desc = "Ask (selection)",
		},
		{
			"<leader>an",
			function()
				require("tmux-agent-bridge").ask("@selection", { new = true, submit = true })
			end,
			mode = "x",
			desc = "Ask New (selection)",
		},
		{
			"<leader>ae",
			function()
				require("tmux-agent-bridge").prompt("Explain the following code:\n\n@selection", { submit = true })
			end,
			mode = "x",
			desc = "Explain selection",
		},
		{
			"<leader>ay",
			function()
				require("tmux-agent-bridge").ask("@selection\n\n")
			end,
			mode = "x",
			desc = "Yank to prompt",
		},
		{
			"<leader>ar",
			function()
				require("tmux-agent-bridge").prompt("Review @this for correctness and readability", { submit = true })
			end,
			mode = "x",
			desc = "Review selection",
		},
		{
			"<leader>at",
			function()
				require("tmux-agent-bridge").prompt("Add tests for @this", { submit = true })
			end,
			mode = "x",
			desc = "Generate tests",
		},
		{
			"<leader>ao",
			function()
				require("tmux-agent-bridge").prompt("Optimize @this for performance and readability", { submit = true })
			end,
			mode = "x",
			desc = "Optimize selection",
		},
		{
			"<leader>aD",
			function()
				require("tmux-agent-bridge").prompt(
					"Add documentation comments to @this. Only document this code, nothing else.",
					{ submit = true }
				)
			end,
			mode = "x",
			desc = "Document selection",
		},
		{
			"<leader>aa",
			function()
				require("tmux-agent-bridge").ask("@buffer ", { submit = true })
			end,
			desc = "Ask",
		},
		{
			"<leader>an",
			function()
				require("tmux-agent-bridge").ask("@buffer ", { new = true, submit = true })
			end,
			desc = "Ask New",
		},
		{
			"<leader>ah",
			function()
				require("tmux-agent-bridge").ask("")
			end,
			desc = "Ask (here)",
		},
		{
			"<leader>ab",
			function()
				require("tmux-agent-bridge").ask("@buffers ")
			end,
			desc = "Ask (buffers)",
		},
		{
			"<leader>aq",
			function()
				require("tmux-agent-bridge").ask("@buffer @quickfix ")
			end,
			desc = "Ask (quickfix)",
		},
		{
			"<leader>ad",
			function()
				require("tmux-agent-bridge").ask("@diff ")
			end,
			desc = "Ask (diff)",
		},
		{
			"<leader>ae",
			function()
				require("tmux-agent-bridge").ask("@diagnostics ")
			end,
			desc = "Ask (diagnostics)",
		},
		{
			"<leader>av",
			function()
				require("tmux-agent-bridge").ask("@visible ")
			end,
			desc = "Ask (visible)",
		},
		{
			"<leader>aD",
			function()
				require("tmux-agent-bridge").prompt(
					"Add documentation comments to the function at @this. Only document this function, nothing else.",
					{ submit = true }
				)
			end,
			desc = "Document function",
		},
		{
			"<leader>as",
			function()
				require("tmux-agent-bridge").select()
			end,
			desc = "Select action",
		},
		{
			"<leader>at",
			function()
				require("tmux-agent-bridge").toggle()
			end,
			desc = "Toggle agent pane",
		},
		{
			"<S-C-u>",
			function()
				require("tmux-agent-bridge").send_keys("PageUp", { agent = "opencode" })
			end,
			desc = "Scroll up",
		},
		{
			"<S-C-d>",
			function()
				require("tmux-agent-bridge").send_keys("PageDown", { agent = "opencode" })
			end,
			desc = "Scroll down",
		},
	},
}
