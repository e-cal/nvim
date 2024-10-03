return {
	-- {
	--     "zbirenbaum/copilot-cmp",
	--     event = "VeryLazy",
	--     dependencies = {
	--         {
	--             "zbirenbaum/copilot.lua",
	--             opts = {
	--                 suggestion = { enabled = false },
	--                 panel = { enabled = false },
	--             },
	--         },
	--     },
	--     opts = {},
	-- },
	{
		"supermaven-inc/supermaven-nvim",
		opts = {
			disable_inline_completion = true,
		},
		config = function(_, opts)
			require("supermaven-nvim").setup(opts)
		end,
		enabled = function()
			local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
			if ok and stats and stats.size > max_filesize then
			    print("disabled supermaven for large file")
				return false
			end
			return true
		end,
	},
}
