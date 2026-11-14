return {
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
	},
}
