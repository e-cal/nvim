return {
	"e-cal/opencode.nvim",
	dir = "~/projects/opencode.nvim",
	lazy = false,
	opts = {
		debug = false,
		auto_connect = true,
		auto_reload = true,
		notify_on_reload = true,
	},
	keys = {
		{
			"<leader>ac",
			function()
				require("opencode").connect()
			end,
			desc = "Connect to opencode",
		},
		{
			"<leader>ad",
			function()
				require("opencode").disconnect()
			end,
			desc = "Disconnect from opencode",
		},
	},
}
