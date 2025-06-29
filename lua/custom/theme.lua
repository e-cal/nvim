vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
	underline = true,
	sp = Utils.brightness_modifier(Utils.get_hl("Normal", "bg"), 100),
})
