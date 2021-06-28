local dap = require('dap')
-- Lua commands to vim commands
Utils.make_command("DebugToggleBreakpoint", "require'dap'.toggle_breakpoint")
Utils.make_command("DebugContinue", "require'dap'.continue")
Utils.make_command("DebugStepInto", "require'dap'.step_into")
Utils.make_command("DebugStepOver", "require'dap'.step_over")
Utils.make_command("DebugStepOut", "require'dap'.step_out")
Utils.make_command("DebugStepBack", "require'dap'.step_back")
Utils.make_command("DebugListBreakpoints", "lua require'dap'.list_breakpoints")
Utils.make_command("DebugToggleRepl", "require'dap'.repl.toggle")

vim.cmd('hi DapBreakpoint guifg=#ff0000')
vim.fn.sign_define('DapBreakpoint', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = '',
    numhl = ''
})

dap.defaults.fallback.external_terminal =
    {command = Debugger.externalTerminal, args = {'-e'}}

-- UI
require("dapui").setup({
    icons = {expanded = "⯆", collapsed = "⯈", circular = "↺"},
    mappings = {expand = "<CR>", open = "o", remove = "d"},
    sidebar = {
        elements = {
            -- You can change the order of elements in the sidebar
            "scopes", "watches", "stacks"
        },
        width = 30,
        position = "left" -- Can be "left" or "right"
    },
    tray = {
        elements = {"repl"},
        height = 10,
        position = "bottom" -- Can be "bottom" or "top"
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil -- Floats will be treated as percentage of your screen.
    }
})

Utils.make_command("DebugFloatElement", "require'dapui'.float_element")
Utils.make_command("DebugEvaluate", "require'dapui'.eval")

-- Python
local opts = {}
if Debugger.useExternalTerminal then opts.console = 'externalTerminal' end
require('dap-python').setup(Debugger.pythonPath, opts)

Utils.make_command("PythonTestMethod", "require'dap-python'.test_method")
Utils.make_command("PythonTestClass", "require'dap-python'.test_class")
Utils.make_command("PythonDebugSelection", "require'dap-python'.debug_selection")
