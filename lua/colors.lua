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

if colorscheme == "deus" then
	vim.cmd("let g:deus_termcolors=256")
	vim.cmd("hi MatchParen cterm=bold guifg=#F4852B guibg=#5C5C5C")
	vim.cmd("hi colorColumn guibg=#343B46")
	vim.cmd("hi GitSignsChange guifg=#E5C07B")
	vim.cmd("hi BufferCurrentSign guifg=#90C966")
	vim.cmd("hi BufferVisibleSign guifg=#73BA9F")
	vim.cmd("hi BufferInactiveSign guifg=#83A598")
elseif colorscheme == "two-firewatch" then
	vim.cmd("hi GitSignsChange guifg=#E5C07B")
	vim.cmd("hi SignColumn guibg=#282C34")
	vim.cmd("hi BufferCurrentSign guifg=#90C966")
	vim.cmd("hi BufferVisibleSign guifg=#73BA9F")
	vim.cmd("hi BufferInactiveSign guifg=#83A598")
elseif colorscheme == "edge" then
	vim.cmd("hi MatchParen cterm=bold guifg=#6cb6eb guibg=#5C5C5C")
	vim.cmd("hi GitSignsChange guifg=#E5C07B")
	vim.cmd("hi BufferVisible guifg=#7f8490 guibg=#33353f")
	vim.cmd("hi BufferVisibleSign guifg=#7f8490 guibg=#33353f")
	vim.cmd("hi BufferVisibleIndex guifg=#7f8490 guibg=#33353f")
	vim.cmd("hi BufferVisibleMod guifg=#deb974 guibg=#33353f")

	vim.cmd("hi VirtualTextError guifg=#ec7279")
	vim.cmd("hi ErrorText guisp=#ec7279")
	vim.cmd("hi VirtualTextWarning guifg=#deb974")
	vim.cmd("hi VirtualTextInfo guifg=#6cb6eb")
	vim.cmd("hi VirtualTextHint guifg=#a0c980")
elseif colorscheme == "palenightfall" then
	require("palenightfall").setup({
		highlight_overrides = {
			Normal = { bg = "#292D3E" },
			Visual = { bg = "#E5C07B", fg = "black" },
		},
	})
end
