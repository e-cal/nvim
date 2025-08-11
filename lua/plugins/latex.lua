return {
	"lervag/vimtex",
	lazy = false,
	keys = {
		{ "<leader>ltt", "<cmd>VimtexCompile<cr>", desc = "toggle compilation" },
	},
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_forward_search_on_start = 0
        vim.g.vimtex_quickfix_enabled = 0

		local augroup = vim.api.nvim_create_augroup
		local autocmd = vim.api.nvim_create_autocmd

		augroup("Vimtex", { clear = true })
		autocmd({ "BufRead" }, {
			group = "Vimtex",
			pattern = "*.tex",
			callback = function()
				vim.cmd("VimtexCompile")
			end,
		})
	end,
}
