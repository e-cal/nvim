return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			lightbulb = { enable = false },
		})
	end,
	keys = {
		{ "K", "<cmd>Lspsaga hover_doc<CR>" },
	},
}
