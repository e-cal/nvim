require('dap')
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
