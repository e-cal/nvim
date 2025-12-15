vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
	underline = true,
	sp = Utils.brightness_modifier(Utils.get_hl("Normal", "bg"), 100),
})

vim.api.nvim_set_hl(0, "Normal", { bg = nil })
vim.api.nvim_set_hl(0, "NormalNC", { bg = nil })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })

vim.api.nvim_set_hl(0, "Folded", { link = "CursorLine" })
