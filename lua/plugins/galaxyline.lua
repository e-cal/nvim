local gl = require('galaxyline')
local colors = {
    black = '#242a32',
    red = '#d54e53',
    green = '#98c379',
    yellow = '#e5c07b',
    orange = '#f4852b',
    blue = '#83a598',
    purple = '#c678dd',
    teal = '#70c0ba',
    white = '#eaeaea',
    grey = '#666666',
    bright_red = '#ec3e45',
    bright_green = '#90c966',
    bright_yellow = '#edbf69',
    bright_blue = '#73ba9f',
    bright_purple = '#c858e9',
    bright_teal = '#2bcec2',
    bright_white = '#ffffff',
    bg = '#242a32',
    fg = '#ebdbb2'
}
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {'NvimTree', 'vista', 'dbui', 'packer'}

gls.left[1] = {
    ViMode = {
        provider = function()
            -- auto change color according the vim mode
            local mode_color = {
                n = colors.bright_blue, -- normal
                no = colors.blue, -- op pending
                v = colors.purple, -- visual
                V = colors.purple, -- visual line
                [''] = colors.purple, -- visual block
                s = colors.orange, -- select
                S = colors.orange, -- select line
                [''] = colors.orange, -- select block
                i = colors.bright_green, -- insert
                ic = colors.yellow, -- insert completion
                R = colors.red, -- replace
                Rv = colors.red, -- virtual replace
                c = colors.yellow, -- command editing
                cv = colors.blue, -- ex (Q) mode
                ce = colors.blue, -- normal ex mode
                r = colors.cyan, -- enter prompt
                rm = colors.cyan, -- more prompt
                ['r?'] = colors.cyan, -- confirm query
                ['!'] = colors.blue, -- shell command executing
                t = colors.blue -- terminal
            }
            vim.api.nvim_command('hi GalaxyViMode guifg=' ..
                                     mode_color[vim.fn.mode()])
            return '▊ '
        end,
        highlight = {colors.red, colors.bg}
    }
}

gls.left[2] = {
    GitIcon = {
        provider = function()
            return ' '
        end,
        condition = condition.check_git_workspace,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.yellow, colors.bg}
    }
}

gls.left[3] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = condition.check_git_workspace,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[4] = {
    DiffAdd = {
        provider = 'DiffAdd',
        icon = '  ',
        highlight = {colors.green, colors.bg}
    }
}
gls.left[5] = {
    DiffModified = {
        provider = 'DiffModified',
        icon = ' ﰣ ',
        highlight = {colors.yellow, colors.bg}
    }
}
gls.left[6] = {
    DiffRemove = {
        provider = 'DiffRemove',
        icon = '  ',
        highlight = {colors.red, colors.bg}
    }
}

gls.right[1] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = {colors.bright_red, colors.bg}
    }
}

gls.right[2] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = {colors.orange, colors.bg}
    }
}

gls.right[3] = {
    DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = '  ',
        highlight = {colors.bright_blue, colors.bg}
    }
}

gls.right[4] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ',
        highlight = {colors.bright_yellow, colors.bg}
    }
}

gls.right[5] = {
    LineInfo = {
        provider = {
            function()
                return string.format('%s/%s:%s', vim.fn.line('.'),
                                     vim.fn.line('$'), vim.fn.col('.'))
            end
        },
        separator = ' ',
        icon = '',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.fg, colors.bg}
    }
}

gls.right[6] = {
    BufferType = {
        provider = 'FileTypeName',
        condition = condition.hide_in_width,
        separator = '  ',
        separator_highlight = {colors.bg, colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[7] = {
    ShowLspClient = {
        provider = 'GetLspClient',
        condition = function()
            local tbl = {['dashboard'] = true, [' '] = true}
            if tbl[vim.bo.filetype] then return false end
            return condition.hide_in_width()
        end,
        icon = ' ',
        separator = '  ',
        separator_highlight = {colors.bg, colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[8] = {
    FileEncode = {
        provider = 'FileEncode',
        condition = condition.hide_in_width,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.grey, colors.bg}
    }
}

gls.right[9] = {
    Space = {
        provider = function()
            return ' '
        end,
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.orange, colors.bg}
    }
}

gls.short_line_left[1] = {
    BufferType = {
        provider = 'FileTypeName',
        separator = ' ',
        separator_highlight = {'NONE', colors.bg},
        highlight = {colors.fg, colors.bg}
    }
}

gls.short_line_left[2] = {
    SFileName = {
        provider = 'SFileName',
        condition = condition.buffer_not_empty,
        highlight = {colors.fg, colors.bg}
    }
}

gls.short_line_right[1] = {
    BufferIcon = {provider = 'BufferIcon', highlight = {colors.fg, colors.bg}}
}
