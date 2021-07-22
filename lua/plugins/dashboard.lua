vim.g.dashboard_custom_header = {
    '███████╗██╗   ██╗██╗███╗   ███╗',
    '██╔════╝██║   ██║██║████╗ ████║',
    '█████╗  ██║   ██║██║██╔████╔██║',
    '██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║',
    '███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║',
    '╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝'
}

vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_section = {
    a = {
        description = {'  Restore Session'},
        command = 'set showtabline=2 | SessionLoad'
    },
    b = {
        description = {'  Files          '},
        command = 'Telescope find_files hidden=true'
    },
    c = {
        description = {'  Find Text      '},
        command = 'Telescope grep_string search="" only_sort_text=true'
    },
    d = {description = {'  Recent Files   '}, command = 'Telescope oldfiles'},
    e = {description = {'  New File       '}, command = 'enew'},
    f = {
        description = {'  Settings       '},
        command = 'e ~/.config/nvim/settings.lua'
    }
}

vim.g.dashboard_custom_footer = {'github.com/e-cal'}
