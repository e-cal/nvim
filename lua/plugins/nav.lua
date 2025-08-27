return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{ "s", "<cmd>lua require('flash').jump()<cr>" },
			{ "s", "<cmd>lua require('flash').jump()<cr>", mode = "x" },
			{ "s", "<cmd>lua require('flash').jump() <cr>", mode = "o" },
			{ "S", "<cmd>lua require('flash').treesitter() <cr>", mode = "n" },
			{ "r", "<cmd>lua require('flash').remote()<cr>", mode = "o" },
			{ "R", "<cmd>lua require('flash').treesitter_search()<cr>", mode = "o" },
			{ "R", "<cmd>lua require('flash').treesitter_search() <cr>", mode = "x" },
			{ "<c-s>", "<cmd>lua require('flash').toggle()<cr>", mode = "c" },
		},
	},
	{
		"stevearc/aerial.nvim",
		event = "VeryLazy",
		opts = {
			nav = {
				preview = true,
				keymaps = {
					["<esc>"] = "actions.close",
					["q"] = "actions.close",
				},
			},
		},
		keys = { { "<leader>S", "m`<cmd>AerialNavToggle<cr>", desc = "aerial" } },
	},
	-- {
	--     "ThePrimeagen/harpoon",
	--     branch = "harpoon2",
	--     config = function()
	--         local harpoon = require("harpoon")
	--         harpoon:setup()
	--         vim.keymap.set("n", "<leader>p", function() harpoon:list():add() end, { desc = "⇁ pin" })
	--         vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "⇁ list" })
	--
	--         vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "⇁ 1" })
	--         vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "⇁ 2" })
	--         vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "⇁ 3" })
	--         vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "⇁ 4" })
	--         vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "⇁ 5" })
	--
	--         vim.keymap.set("n", "<leader>j", function() harpoon:list():next() end, { desc = "⇁ next" })
	--         vim.keymap.set("n", "<leader>k", function() harpoon:list():prev() end, { desc = "⇁ prev" })
	--     end
	-- },

	{
		"cbochs/grapple.nvim",
		dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
		opts = { scope = "git" },
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "⇁ mark" },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "⇁ menu" },

			{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "⇁ 1" },
			{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "⇁ 2" },
			{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "⇁ 3" },
			{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "⇁ 4" },
			-- { "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			-- { "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
		},
	},
}
