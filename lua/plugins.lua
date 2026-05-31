local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

local specs = {}
local plugin_files = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugins/*.lua", false, true)
table.sort(plugin_files)
for _, file in ipairs(plugin_files) do
	local spec = dofile(file)
	if spec then
		table.insert(specs, spec)
	end
end

require("lazy").setup(specs, { change_detection = { enabled = false } })
vim.cmd("hi TreesitterContextBottom gui=NONE")
