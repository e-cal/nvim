return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		autoFold = { enabled = false },
		foldKeymaps = { setup = false },
	},
    keys = {
        { "H", function() require("origami").h() end, desc = "Fold: Move h (with peek)" },
        { "L", function() require("origami").l() end, desc = "Fold: Move l (with peek)" },
        { "$", function() require("origami").dollar() end, desc = "Fold: End of line (with peek)" },
        { "^", function() require("origami").caret() end, desc = "Fold: Start of line (with peek)" },
    },

	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
	end,
}
