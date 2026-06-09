return {
	"kevinhwang91/nvim-bqf",
	event = "VeryLazy",
	keys = {
		{ "<leader>qo", "<cmd>copen<cr>", desc = "Quickfix open" },
		{ "<leader>qc", "<cmd>cclose<cr>", desc = "Quickfix close" },
	},
	config = function(_, opts)
		require("bqf").setup(opts)

		local handler = require("bqf.qfwin.handler")
		local sessions = require("bqf.qfwin.session")
		local open = handler.open

		handler.open = function(...)
			local qwinid = select(3, ...) or vim.api.nvim_get_current_win()
			local session = sessions:get(qwinid)
			local pwinid = session and session:previousWinid()

			if pwinid and vim.api.nvim_win_is_valid(pwinid) then
				vim.api.nvim_set_current_win(pwinid)
				vim.cmd([[normal! m']])
				vim.api.nvim_set_current_win(qwinid)
			end

			return open(...)
		end
	end,
	opts = {
		auto_resize_height = false,
		filter = {
			fzf = {
				action_for = {
					["ctrl-c"] = "closeall",
					["ctrl-q"] = "signtoggle",
					["ctrl-t"] = "tabedit",
					["ctrl-v"] = "vsplit",
					["ctrl-x"] = "split",
				},
				extra_opts = { "--bind", "ctrl-o:toggle-all" },
			},
		},
		func_map = {
			filter = "F",
			filterr = "d",
			fzffilter = "/",
			nexthist = "l",
			prevhist = "h",
			nextfile = "<C-n>",
			prevfile = "<C-p>",
			ptoggleauto = "P",
			ptoggleitem = "p",
			open = "<cr>",
			-- openc = "<CR>",
			split = "s",
			vsplit = "v",
			stogglevm = "<Tab>",

			drop = "O",
			lastleave = "'\"",
			pscrolldown = "<C-f>",
			pscrollorig = "zo",
			pscrollup = "<C-b>",
			ptogglemode = "zp",
			sclear = "z<Tab>",
			-- stogglebuf = "<Tab>",
			stoggledown = "<space>",
			stoggleup = "<S-Tab>",
			tab = "t",
			tabb = "T",
			tabc = "<C-t>",
			tabdrop = "",
		},
		magic_window = true,
		preview = {
			auto_preview = false,
			border = "rounded",
			buf_label = true,
			delay_syntax = 50,
			show_scroll_bar = true,
			show_title = true,
			win_height = 15,
			win_vheight = 15,
			winblend = 12,
			wrap = false,
		},
		previous_winid_ft_skip = {},
	},
}
