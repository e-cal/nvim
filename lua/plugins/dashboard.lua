local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	"███████╗██╗   ██╗██╗███╗   ███╗",
	"██╔════╝██║   ██║██║████╗ ████║",
	"█████╗  ██║   ██║██║██╔████╔██║",
	"██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║",
	"███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║",
	"╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
}
dashboard.section.header.opts.hl = "DashboardHeader"

local function button(sc, txt)
	-- replace <leader> in shortcut text with LDR for nicer printing
	local sc_ = sc:gsub("%s", ""):gsub("LDR", "<leader>")
	-- if the leader is set, replace the text with the actual leader key for nicer printing
	sc = sc:gsub("LDR", "󱁐")
	-- return the button entity to display the correct text and send the correct keybinding on press
	return {
		type = "button",
		val = txt,
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
			vim.api.nvim_feedkeys(key, "normal", false)
		end,
		opts = {
			position = "center",
			text = txt,
			shortcut = sc,
			cursor = 5,
			width = 36,
			align_shortcut = "right",
			hl = "DashboardCenter",
			hl_shortcut = "DashboardShortcut",
		},
	}
end

dashboard.section.buttons.val = {
	button("LDR h", "󱡀  Harpoon  "),
	button("LDR o", "  Find File  "),
	button("LDR t r", "  History  "),
	button("LDR t t", "󰺮  Find Text  "),
	button("LDR t m", "  Bookmarks  "),
	button("LDR n", "  New File  "),
	{
		type = "button",
		val = "󰩈  Quit",
		on_press = function()
			vim.cmd("qa")
		end,
		opts = {
			position = "center",
			text = "󰩈  Quit",
			shortcut = "q",
			keymap = { "n", "q", "<cmd>qa<cr>", { silent = true } },
			cursor = 5,
			width = 36,
			align_shortcut = "right",
			hl = "DashboardCenter",
			hl_shortcut = "DashboardShortcut",
		},
	},
}

dashboard.section.footer.val = "https://github.com/e-cal/evim"

dashboard.config.layout[1].val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) })
dashboard.config.layout[3].val = 5
dashboard.config.opts.noautocmd = true
dashboard.config.keymap = {}

require("alpha").setup(dashboard.config)
