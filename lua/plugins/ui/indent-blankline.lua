return {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
	opts = {
		enabled = false,
		debounce = 200,
		viewport_buffer = { min = 30, max = 500 },
		indent = { char = "╎", highlight = "IBLChar", smart_indent_cap = true },
		whitespace = { remove_blankline_trail = true },
		scope = { enabled = true, highlight = "IBLScope", injected_languages = true },
	},
	config = function(_, opts)
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			local char = Utils.get_hl("ColorColumn", "bg")
			vim.api.nvim_set_hl(0, "IBLChar", { fg = char, nocombine = true })
			vim.api.nvim_set_hl(0, "IBLScope", { fg = Utils.brightness_modifier(char, 50), nocombine = true })
		end)
		require("ibl").setup(opts)
	end,
	keys = { { "<leader>i", "<cmd>IBLToggle<cr>", desc = "toggle indent lines" } },
}
