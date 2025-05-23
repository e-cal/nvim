return {
	{
		"numToStr/Navigator.nvim",
		event = "VeryLazy",
		config = true,
		keys = {
			{ "<M-h>", "<cmd>lua require('Navigator').left()<cr>" },
			{ "<M-l>", "<cmd>lua require('Navigator').right()<cr>" },
			{ "<M-k>", "<cmd>lua require('Navigator').up()<cr>" },
			{ "<M-j>", "<cmd>lua require('Navigator').down()<cr>" },
		},
	},
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
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end, { desc = "⇁ add" })
            vim.keymap.set("n", "<leader>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "⇁ menu" })

            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "⇁ 1" })
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "⇁ 2" })
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "⇁ 3" })
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "⇁ 4" })
            vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "⇁ 5" })

            vim.keymap.set("n", "<leader>j", function() harpoon:list():next() end, { desc = "⇁ next" })
            vim.keymap.set("n", "<leader>k", function() harpoon:list():prev() end, { desc = "⇁ prev" })
        end
    },
}
