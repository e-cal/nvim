return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		iron.setup({
			config = {
				scratch_repl = true,
				repl_definition = {
					sh = {
						command = { "zsh" },
					},
					python = {
						command = { "ipython", "--no-autoindent" },
						-- format = require("iron.fts.common").bracketed_paste_python,
					},
				},
				repl_open_cmd = "20 split",
			},
			keymaps = {
				send_line = "<leader>rl",
				send_motion = "<leader>rs",
				send_file = "<leader>ra",
				send_paragraph = "<leader>rp",
				send_until_cursor = "<leader>rh",
				send_mark = "<leader>rm",
				mark_motion = "<leader>rM",
				remove_mark = "<leader>rdm",
				cr = "<leader>r<cr>",
				interrupt = "<leader>rx",
				exit = "<leader>rq",
				clear = "<leader>rc",
				visual_send = "<leader>r",
				mark_visual = "<leader>m",
			},
			highlight = { italic = false },
			ignore_blank_lines = true,
		})
	end,
	keys = {
		{ "<leader>rf", "<cmd>IronFocus<cr>", desc = "focus" },
		{ "<leader>rR", "<cmd>IronRestart<cr>", desc = "restart" },
		{ "<leader>rr", "<cmd>IronRepl<cr>", desc = "init/toggle" },
		{ "<leader>rH", "<cmd>IronHide<cr>", desc = "hide" },
	},
}
