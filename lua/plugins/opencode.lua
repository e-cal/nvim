return {
	"e-cal/opencode.nvim",
	--dir = "~/projects/opencode.nvim",
	lazy = false,
	opts = {
		debug = false,
		auto_connect = true,
		auto_reload = true,
		notify_on_reload = true,
	},
	keys = {
		{
			"<leader>Oc",
			function()
				require("opencode").connect()
			end,
			desc = "Connect",
		},
		{
			"<leader>Od",
			function()
				require("opencode").disconnect()
			end,
			desc = "Disconnect",
		},
		{
			"<leader>Op",
			function()
				require("opencode").send_smart_prompt()
			end,
			desc = "Prompt",
		},
	},
}
