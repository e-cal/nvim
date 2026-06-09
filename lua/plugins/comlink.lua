return {
	"e-cal/comlink.nvim",
	dir = (function()
		local path = vim.fn.expand("~/projects/comlink.nvim")
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
				submit_on_write = false,
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
				require("comlink").prompt(
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
				require("comlink").ask("@selection", { submit = true })
			end,
			mode = "x",
			desc = "Ask (selection)",
		},
		{
			"<leader>an",
			function()
				require("comlink").ask("@selection", { new = true, submit = true })
			end,
			mode = "x",
			desc = "Ask New (selection)",
		},
		{
			"<leader>ae",
			function()
				require("comlink").prompt("Explain the following code:\n\n@selection", { submit = true })
			end,
			mode = "x",
			desc = "Explain selection",
		},
		{
			"<leader>ad",
			function()
				require("comlink").ask("@selection\n\n@diagnostics ", { submit = true })
			end,
			mode = "x",
			desc = "Ask (selection diagnostics)",
		},
		{
			"<leader>ay",
			function()
				require("comlink").ask("@selection\n\n")
			end,
			mode = "x",
			desc = "Yank to prompt",
		},
		{
			"<leader>ar",
			function()
				require("comlink").prompt("Review @this for correctness and readability", { submit = true })
			end,
			mode = "x",
			desc = "Review selection",
		},
		{
			"<leader>at",
			function()
				require("comlink").prompt("Add tests for @this", { submit = true })
			end,
			mode = "x",
			desc = "Generate tests",
		},
		{
			"<leader>ao",
			function()
				require("comlink").prompt("Optimize @this for performance and readability", { submit = true })
			end,
			mode = "x",
			desc = "Optimize selection",
		},
		{
			"<leader>aD",
			function()
				require("comlink").prompt(
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
				require("comlink").ask("@buffer ", { submit = true })
			end,
			desc = "Ask",
		},
		{
			"<leader>an",
			function()
				require("comlink").ask("@buffer ", { new = true, submit = true })
			end,
			desc = "Ask New",
		},
		{
			"<leader>al",
			function()
				require("comlink").ask("@line ")
			end,
			desc = "Ask (line)",
		},
		{
			"<leader>ab",
			function()
				require("comlink").ask("@buffers ")
			end,
			desc = "Ask (buffers)",
		},
		{
			"<leader>aq",
			function()
				require("comlink").ask("@buffer @quickfix ")
			end,
			desc = "Ask (quickfix)",
		},
		{
			"<leader>ad",
			function()
				require("comlink").ask("@diff ")
			end,
			desc = "Ask (diff)",
		},
		{
			"<leader>ae",
			function()
				require("comlink").ask("@diagnostics ")
			end,
			desc = "Ask (diagnostics)",
		},
		{
			"<leader>av",
			function()
				require("comlink").ask("@visible ")
			end,
			desc = "Ask (visible)",
		},
		{
			"<leader>aD",
			function()
				require("comlink").prompt(
					"Add documentation comments to the function at @this. Only document this function, nothing else.",
					{ submit = true }
				)
			end,
			desc = "Document function",
		},
		{
			"<leader>as",
			function()
				require("comlink").select()
			end,
			desc = "Select action",
		},
		{
			"<leader>at",
			function()
				require("comlink").toggle()
			end,
			desc = "Toggle agent pane",
		},
		{
			"<S-C-u>",
			function()
				require("comlink").send_keys("PageUp", { agent = "opencode" })
			end,
			desc = "Scroll up",
		},
		{
			"<S-C-d>",
			function()
				require("comlink").send_keys("PageDown", { agent = "opencode" })
			end,
			desc = "Scroll down",
		},
	},
}
