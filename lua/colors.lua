vim.go.t_Co = "256"
vim.go.termguicolors = true
vim.go.background = "dark"
vim.cmd('let &t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"')
vim.cmd('let &t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"')

local colorscheme = "catppuccin"

if colorscheme == "catppuccin" then
	vim.g.catppuccin_flavour = "macchiato"
end
vim.cmd("colorscheme " .. colorscheme)

