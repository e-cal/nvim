vim.g.dashboard_custom_header = {
'███████╗██╗   ██╗██╗███╗   ███╗',
'██╔════╝██║   ██║██║████╗ ████║',
'█████╗  ██║   ██║██║██╔████╔██║',
'██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║',
'███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║',
'╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
}

vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
    a = {description = {'  New File       '}, command = 'enew'},
    b = {description = {'  Files          '}, command = 'Telescope find_files hidden=true'},
    c = {description = {'  Find Text      '}, command = 'Telescope live_grep'},
    d = {description = {'  Recent Files   '}, command = 'Telescope oldfiles'},
    e = {description = {'  Restore Session'}, command = 'set showtabline=2 | SessionLoad'},
    f = {description = {'  Settings       '}, command = 'e ~/.config/nvim/settings.lua'}
}

vim.g.dashboard_custom_footer = {'github.com/e-cal'}
