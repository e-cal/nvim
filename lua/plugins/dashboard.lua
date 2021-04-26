-- vim.g.dashboard_custom_header = {
-- ' _______          _________ _______ ',
-- '(  ____ \\|\\     /|\\__   __/(       )',
-- '| (    \\/| )   ( |   ) (   | () () |',
-- '| (__    | |   | |   | |   | || || |',
-- '|  __)   ( (   ) )   | |   | |(_)| |',
-- '| (       \\ \\_/ /    | |   | |   | |',
-- '| (____/\\  \\   /  ___) (___| )   ( |',
-- '(_______/   \\_/   \\_______/|/     \\|',
-- }


-- vim.g.dashboard_custom_header = {
-- '_______________   ____.__         ',
-- '\\_   _____/\\   \\ /   /|__| _____  ',
-- ' |    __)_  \\   Y   / |  |/     \\ ',
-- ' |        \\  \\     /  |  |  Y Y  \\',
-- '/_______  /   \\___/   |__|__|_|  /',
-- '        \\/                     \\/ ',
-- }

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
    a = {description = {'  Restore Session'}, command = 'set showtabline=2 | SessionLoad'},
    b = {description = {'  Recent Files   '}, command = 'Telescope oldfiles'},
    c = {description = {'  Find File      '}, command = 'Telescope find_files'},
    d = {description = {'  Find Text      '}, command = 'Telescope live_grep'},
    e = {description = {'  Settings       '}, command = ':e ~/.config/nvim/settings.lua'}
}

vim.g.dashboard_custom_shortcut = {
    a = 'f',
    find_word = 'SPC f a',
    last_session = 'SPC s l',
    new_file = 'SPC c n',
    book_marks = 'SPC f b'
}

vim.g.dashboard_custom_footer = {'github.com/e-cal'}
