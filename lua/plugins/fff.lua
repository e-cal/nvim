return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	-- build = "nix run .#release",
	opts = {
		title = "Files",
		prompt = "  ",
		layout = {
			path_shorten_strategy = "middle",
		},
	},
	config = function(_, opts)
		require("fff").setup(opts)

		local group = vim.api.nvim_create_augroup("FffEscBehavior", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = { "fff_input", "fff_list", "fff_preview" },
			callback = function(event)
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(event.buf) then
						return
					end

					vim.keymap.set("n", "<Esc>", function()
						require("fff.picker_ui").close()
					end, { buffer = event.buf, silent = true, desc = "Close fff" })

					if vim.bo[event.buf].filetype == "fff_input" then
						vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = event.buf, silent = true, desc = "Exit insert in fff" })
					end
				end)
			end,
		})
	end,
	lazy = false,
	keys = {
		{
			"ff",
			function()
				require("fff").find_files()
			end,
			desc = "files",
		},
		{
			"<leader>o",
			function()
				require("fff").find_files()
			end,
			desc = "files",
		},
		{
			"fg",
			function()
				require("fff").live_grep()
			end,
			desc = "live grep",
		},
		{
			"fz",
			function()
				require("fff").live_grep({
					grep = {
						modes = { "fuzzy", "plain" },
					},
				})
			end,
			desc = "fuzy grep",
		},
		{
			"fw",
			function()
				require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			end,
			desc = "search word",
		},
	},
}
