local dap = require("dap")
-- Lua commands to vim commands
-- vim.api.nvim_command(string.format("command! -nargs=%s %s lua %s", nargs, name, name))
vim.api.nvim_command("command! DebugToggleBreakpoint lua require'dap'.toggle_breakpoint()")
vim.api.nvim_command("command! DebugContinue lua require'dap'.continue()")
vim.api.nvim_command("command! DebugStepInto lua require'dap'.step_into()")
vim.api.nvim_command("command! DebugStepOver lua require'dap'.step_over()")
vim.api.nvim_command("command! DebugStepOut lua require'dap'.step_out()")
vim.api.nvim_command("command! DebugStepBack lua require'dap'.step_back()")
vim.api.nvim_command("command! DebugToggleRepl lua require'dap'.repl.toggle()")
vim.api.nvim_command("command! DebugListBreakpoints lua require'dap'.list_breakpoints(0)")
vim.api.nvim_command("command! DebugRestart lua require'dap'.restart()")
vim.api.nvim_command("command! DebugTerminate lua require'dap'.terminate()")
vim.api.nvim_command("command! DebugGoto lua require'dap'.goto_()")
vim.api.nvim_command("command! DebugFocusFrame lua require'dap'.focus_frame()")

vim.cmd("hi DapBreakpoint guifg=#ff0000")
vim.fn.sign_define("DapBreakpoint", {
	text = "",
	texthl = "DapBreakpoint",
	linehl = "",
	numhl = "",
})

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "OpenDebugAD7",
}
dap.configurations.c = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			-- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			-- file=%; out="${file\\%.*}"
			-- run `gcc -g -o %`

			local file = vim.fn.expand("%")
			-- file without extension
			local out = file:gsub("%..*", "")
			local cmd = "g++ -g -o " .. out .. " " .. file
			vim.cmd("!" .. cmd)
			return out
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "localhost:1234",
		miDebuggerPath = "/usr/bin/gdb",
		cwd = "${workspaceFolder}",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
}

dap.configurations.cpp = dap.configurations.c

-- UI
local dapui = require("dapui")

dapui.setup({
	icons = { expanded = "⯆", collapsed = "⯈", circular = "↺" },
	mappings = { expand = "<CR>", open = "o", remove = "d" },
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
	},
	layouts = {
		{
			elements = {
				"scopes",
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10,
			position = "bottom",
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.api.nvim_command("command! DebugFloatUI lua require'dapui'.float_element()")
vim.api.nvim_command("command! DebugToggleUI lua require'dapui'.toggle()")
vim.api.nvim_command("command! DebugEval lua require'dapui'.eval()")
