vim.g.dashboard_custom_header = {
	"███████╗██╗   ██╗██╗███╗   ███╗",
	"██╔════╝██║   ██║██║████╗ ████║",
	"█████╗  ██║   ██║██║██╔████╔██║",
	"██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║",
	"███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║",
	"╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

vim.g.dashboard_default_executive = "telescope"

vim.g.dashboard_custom_section = {
	a = {
		description = { "  Files          " },
		command = "Telescope find_files hidden=true",
	},
	b = { description = { "  Recent Files   " }, command = "Telescope oldfiles" },
	c = { description = { "  New File       " }, command = "enew" },
	d = {
		description = { "  Find Text      " },
		command = 'Telescope grep_string search="" only_sort_text=true',
	},
	e = {
		description = { "  Restore Session" },
		command = "set showtabline=2 | SessionLoad",
	},
	f = {
		description = { "  Settings       " },
		command = "e ~/.config/nvim/settings.lua",
	},
}

vim.g.dashboard_custom_footer = { "github.com/e-cal" }
