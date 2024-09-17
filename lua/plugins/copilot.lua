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
	},
}
