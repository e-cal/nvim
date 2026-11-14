return {
	"rcarriga/nvim-notify",
	lazy = false,
	opts = {
		background_colour = "CursorLine",
		render = "minimal",
		stages = "fade",
		top_down = false,
	},
	config = function(_, opts)
		local notify = require("notify")
		notify.setup(opts)
		vim.notify = notify
	end,
}
