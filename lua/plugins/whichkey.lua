local wk = require('which-key')
wk.setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = {['<C-_>'] = "Comments"},
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "shadow", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 3, 0, 0}, -- extra window margin [top, right, bottom, left]
        padding = {1, 1, 1, 1} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 10}, -- min and max height of the columns
        width = {min = 20, max = 300}, -- min and max width of the columns
        spacing = 5 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}

-- vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- NORMAL mode
local nopts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local nmappings = {
    [' '] = 'which_key_ignore',
    p = 'print var below',
    P = 'print var above',
    f = {'<cmd>Telescope find_files<cr>', 'find files'},
    H = {'<cmd>Dashboard<cr>', 'home'},
    ['/'] = {'<cmd>CommentToggle<cr>', 'toggle comment'},
    ['?'] = {'<cmd>NvimTreeFindFile<cr>', 'find current file'},
    e = {'<cmd>NvimTreeToggle<cr>', 'explorer'},
    s = {'<cmd>w<cr>', 'save'},
    S = {'<cmd>SessionSave<cr>', 'save session'},
    q = {'<cmd>wqa<cr>', 'save & quit'},
    Q = {'<cmd>qa!<cr>', 'force quit'},
    W = {'<cmd>close<cr>', 'close window'},
    x = {'<cmd>BufferClose<cr>', 'close buffer'},
    ['.'] = {'<cmd>luafile %<cr>', 'source file'},
    h = {'<cmd>sp<cr>', 'split below'},
    v = {'<cmd>vert sp<cr>', 'split right'},
    i = {'<cmd>PasteImg<cr>', 'paste image'},
    T = {'<cmd>ToggleTerm<cr>', 'toggle terminal'},
    n = {'<cmd>enew<cr>', 'new buffer'},
    R = {'<cmd>e<cr>', 'reload buffer'},

    b = {
        name = '+buffer',
        ['>'] = {'<cmd>BufferMoveNext<cr>', 'move right'},
        ['<'] = {'<cmd>BufferMovePrevious<cr>', 'move left'},
        b = {'<cmd>BufferPick<cr>', 'pick buffer'},
        c = {'<cmd>BufferClose<cr>', 'close buffer'},
        n = {'<cmd>BufferNext<cr>', 'next buffer'},
        p = {'<cmd>BufferPrevious<cr>', 'prev buffer'}
    },

    d = {
        name = '+debug',
        b = {'<cmd>DebugToggleBreakpoint<cr>', 'toggle breakpoint'},
        c = {'<cmd>DebugContinue<cr>', 'continue'},
        j = {'<cmd>DebugStepInto<cr>', 'step into'},
        o = {'<cmd>DebugStepOver<cr>', 'step over'},
        O = {'<cmd>DebugStepOut<cr>', 'step out'},
        k = {'<cmd>DebugStepBack<cr>', 'step back'},
        t = {'<cmd>DebugToggleRepl<cr>', 'toggle repl'},
        l = {'<cmd>DebugListBreakpoints<cr>', 'list breakpoints'},
        f = {'<cmd>DebugFloatElement<cr>', 'float ui element'},
        p = {
            name = '+python',
            m = {'<cmd>PythonTestMethod<cr>', 'test method'},
            c = {'<cmd>PythonTestClass<cr>', 'test class'}
        }
    },

    F = {
        name = '+fold',
        O = {'<cmd>set foldlevel=20<cr>', 'open all'},
        C = {'<cmd>set foldlevel=0<cr>', 'close all'},
        c = {'<cmd>foldclose<cr>', 'close'},
        o = {'<cmd>foldopen<cr>', 'open'},
        ['1'] = {'<cmd>set foldlevel=1<cr>', 'level1'},
        ['2'] = {'<cmd>set foldlevel=2<cr>', 'level2'},
        ['3'] = {'<cmd>set foldlevel=3<cr>', 'level3'},
        ['4'] = {'<cmd>set foldlevel=4<cr>', 'level4'},
        ['5'] = {'<cmd>set foldlevel=5<cr>', 'level5'},
        ['6'] = {'<cmd>set foldlevel=6<cr>', 'level6'}
    },

    t = {
        name = '+telescope',
        ['.'] = {
            '<cmd>lua require("plugins.telescope").search_dotfiles{}<cr>',
            'config'
        },
        ['?'] = {'<cmd>Telescope filetypes<cr>', 'filetypes'},
        g = {'<cmd>Telescope git_branches<cr>', 'git branches'},
        b = {'<cmd>Telescope buffers<cr>', 'buffers'},
        f = {'<cmd>Telescope find_files<cr>', 'files'},
        h = {'<cmd>Telescope command_history<cr>', 'cmd history'},
        p = {'<cmd>Telescope media_files<cr>', 'media'},
        m = {'<cmd>Telescope marks<cr>', 'marks'},
        M = {'<cmd>Telescope man_pages<cr>', 'manuals'},
        o = {'<cmd>Telescope vim_options<cr>', 'options'},
        t = {'<cmd>Telescope live_grep<cr>', 'text'},
        s = {'<cmd>Telescope grep_string<cr>', 'selected string'},
        r = {'<cmd>Telescope oldfiles<cr>', 'recents'},
        R = {'<cmd>Telescope registers<cr>', 'registers'},
        w = {'<cmd>Telescope file_browser<cr>', 'fuzzy find'},
        c = {'<cmd>Telescope colorscheme<cr>', 'colorschemes'}
    },

    g = {
        name = '+git',
        b = {'<cmd>Git blame_line<CR>', 'blame'},
        B = {'<cmd>GBrowse<cr>', 'browse'},
        d = {'<cmd>Git diff<cr>', 'diff'},
        j = {'<cmd>Git next_hunk<CR>', 'next hunk'},
        k = {'<cmd>Git prev_hunk<CR>', 'prev hunk'},
        L = {'<cmd>Git log<cr>', 'log'},
        p = {'<cmd>Git preview_hunk<CR>', 'preview hunk'},
        r = {'<cmd>Git reset_hunk<CR>', 'reset hunk'},
        R = {'<cmd>Git reset_buffer<CR>', 'reset buffer'},
        s = {'<cmd>Git stage_hunk<CR>', 'stage hunk'},
        S = {'<cmd>Gstatus<cr>', 'status'},
        u = {'<cmd>Git undo_stage_hunk<CR>', 'undo stage hunk'},
        g = {'<cmd>lua LazygitToggle()<CR>', 'lazygit'}
    },

    l = {
        name = '+lsp',
        a = {'<cmd>Lspsaga code_action<cr>', 'code action'},
        A = {'<cmd>Lspsaga range_code_action<cr>', 'selected action'},
        d = {'<cmd>Telescope lsp_document_diagnostics<cr>', 'doc diagnostics'},
        D = {
            '<cmd>Telescope lsp_workspace_diagnostics<cr>',
            'workspace diagnostics'
        },
        f = {'<cmd>LspFormatting<cr>', 'format'},
        F = {'<cmd>FormatToggle<cr>', 'toggle formatting'},
        ['?'] = {'<cmd>LspInfo<cr>', 'lsp info'},
        v = {'<cmd>LspVirtualTextToggle<cr>', 'toggle virtual text'},
        l = {'<cmd>Lspsaga lsp_finder<cr>', 'lsp finder'},
        L = {'<cmd>Lspsaga show_line_diagnostics<cr>', 'line diagnostics'},
        p = {'<cmd>Lspsaga preview_definition<cr>', 'preview definition'},
        q = {'<cmd>Telescope quickfix<cr>', 'quickfix'},
        r = {'<cmd>Lspsaga rename<cr>', 'rename'},
        T = {'<cmd>LspTypeDefinition<cr>', 'type defintion'},
        x = {'<cmd>cclose<cr>', 'close quickfix'},
        s = {'<cmd>Telescope lsp_document_symbols<cr>', 'document symbols'},
        S = {'<cmd>Telescope lsp_workspace_symbols<cr>', 'workspace symbols'},
        R = {'<cmd>LspRestart<cr>', 'restart lsp'},
        i = {'<cmd>normal A  # type: ignore<cr>bbbbhhh', 'pyright ignore'}
    },

    m = {
        name = '+markdown',
        p = {'<cmd>MarkdownPreview<cr>', 'preview'},
        s = {'<cmd>MarkdownPreviewStop<cr>', 'stop preview'},
        t = {'<cmd>MarkdownPreviewToggle<cr>', 'toggle preview'}
    },

    w = {
        name = '+window',
        ['<'] = {'<C-w><', 'resize left'},
        ['>'] = {'<C-w>>', 'resize right'},
        ['-'] = {'<C-w>-', 'resize down'},
        ['+'] = {'<C-w>+', 'resize height'},
        ['='] = {'<C-w>=', 'reset window'},
        h = {'<cmd>split<cr>', 'split horizontal'},
        v = {'<cmd>vsplit<cr>', 'split vertical'},
        d = {'<cmd>close<cr>', 'close split window'}
    },

    r = {
        name = '+run',
        r = {'<Plug>SnipRunOperator', 'run <movement>'},
        l = {'<Plug>SnipRun', 'run line'},
        a = {'<cmd>%SnipRun<cr>', 'run all'},
        c = {'<Plug>SnipClose', 'clear output'},
        x = {'<Plug>SnipReset', 'reset'},
        d = {'<Plug>SnipReplMemoryClean', 'clear memory'},
        i = {'<Plug>SnipInfo', 'info'},
        p = {
            name = "+ipython",
            p = {'<cmd>IPython<cr>', 'start kernel'},
            r = {'<Plug>(IPy-RunOp)', 'run'},
            c = {'<Plug>(IPy-RunCell)', 'run cell'},
            a = {'<Plug>(IPy-RunAll)', 'run all'},
            l = {'<Plug>(IPy-Run)', 'run line'},
            i = {'<Plug>(IPy-WordObjInfo)', 'inspect'},
            x = {'<Plug>(IPy-Interrupt)', 'interrupt kernel'},
            q = {'<Plug>(IPy-Terminate)', 'terminate kernel'}
        }
    }

}

wk.register(nmappings, nopts)

-- Visual mode
local vopts = {
    mode = "v",
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local vmappings = {
    r = {'<Plug>SnipRun', 'run selection'},
    p = {'<Plug>(IPy-Run)', 'ipython run selection'},

    d = {
        name = '+debug',
        e = {'<cmd>DebugEvaluate<cr>', 'evaluate selected expression'},
        s = {'<cmd>PythonDebugSelection<cr>', 'py debug selection'}
    }

}

wk.register(vmappings, vopts)
