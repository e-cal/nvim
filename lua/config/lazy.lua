local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.ai" },
	{ import = "plugins.editing" },
	{ import = "plugins.git" },
	{ import = "plugins.languages" },
	{ import = "plugins.lsp" },
	{ import = "plugins.navigation" },
	{ import = "plugins.ui" },
}, { change_detection = { enabled = false } })
