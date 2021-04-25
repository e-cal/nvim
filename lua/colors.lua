vim.o.t_Co="256"
vim.o.termguicolors=true
vim.o.background="dark"
vim.cmd('let &t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"')
vim.cmd('let &t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"')
vim.cmd('let g:deus_termcolors=256')

vim.cmd('colorscheme deus')

vim.cmd('hi ColorColumn guibg=#343B46')
vim.cmd('hi GitSignsChange guifg=#E5C07B')
vim.cmd('hi BufferCurrentSign guifg=#90C966 ')
vim.cmd('hi BufferVisibleSign guifg=#73BA9F ')
vim.cmd('hi BufferInactiveSign guifg=#83A598 ')

