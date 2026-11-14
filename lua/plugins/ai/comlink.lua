local function ask(default, opts)
	return function()
		require("comlink").ask(default, opts)
	end
end

local function prompt(text, opts)
	return function()
		require("comlink").prompt(text, opts or { submit = true })
	end
end

return {
	"e-cal/comlink.nvim",
	dir = (function()
		local path = vim.fn.expand("~/projects/comlink.nvim")
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
		return nil
	end)(),
	-- Loaded at startup so the file watcher reloads buffers that agents edit.
	lazy = false,
	dependencies = {
		"rcarriga/nvim-notify",
	},
	opts = {
		-- The terminal (Tern, Rex or tmux) is detected; set terminal = "tern" to force one.
		agent = "pi", -- Started when no agent pane is beside Neovim; "omp" also works.
		launch = {
			direction = "right",
			size = 40,
		},
		ask = {
			wrap = true,
			submit_keys = {
				n = { "<CR>" },
				i = { "<C-s>" },
			},
		},
		agents = {
			arc = {
				name = "Arc",
				cmd = "arc",
				detect = function(pane)
					for _, proc in ipairs(pane.processes) do
						local cmdline = table.concat(proc.argv, " ")
						if vim.fs.basename(proc.argv[1] or "") == "arc" or cmdline:find("/arc-harness/", 1, true) then
							return true
						end
					end
					return false
				end,
				keys = {
					submit = { "enter" },
					clear = { "ctrl+u" },
					new = { "ctrl+x", "n" },
				},
			},
		},
	},
	keys = {
		{
			"<leader>ac",
			prompt("Follow any instructions in the selected code and complete the functionality:\n\n@selection"),
			mode = "x",
			desc = "Complete",
		},
		{ "<leader>aa", ask("@selection", { submit = true }), mode = "x", desc = "Ask (selection)" },
		{ "<leader>an", ask("@selection", { new = true, submit = true }), mode = "x", desc = "Ask New (selection)" },
		{ "<leader>ae", prompt("Explain the following code:\n\n@selection"), mode = "x", desc = "Explain selection" },
		{
			"<leader>ad",
			ask("@selection\n\n@diagnostics ", { submit = true }),
			mode = "x",
			desc = "Ask (selection diagnostics)",
		},
		{ "<leader>ay", ask("@selection\n\n"), mode = "x", desc = "Yank to prompt" },
		{ "<leader>ar", prompt("Review @this for correctness and readability"), mode = "x", desc = "Review selection" },
		{ "<leader>at", prompt("Add tests for @this"), mode = "x", desc = "Generate tests" },
		{
			"<leader>ao",
			prompt("Optimize @this for performance and readability"),
			mode = "x",
			desc = "Optimize selection",
		},
		{
			"<leader>aD",
			prompt("Add documentation comments to @this. Only document this code, nothing else."),
			mode = "x",
			desc = "Document selection",
		},
		{ "<leader>aa", ask("@buffer ", { submit = true }), desc = "Ask" },
		{ "<leader>an", ask("@buffer ", { new = true, submit = true }), desc = "Ask New" },
		{ "<leader>al", ask("@line "), desc = "Ask (line)" },
		{ "<leader>ab", ask("@buffers "), desc = "Ask (buffers)" },
		{ "<leader>aq", ask("@buffer @quickfix "), desc = "Ask (quickfix)" },
		{ "<leader>ad", ask("@diff "), desc = "Ask (diff)" },
		{ "<leader>ae", ask("@diagnostics "), desc = "Ask (diagnostics)" },
		{ "<leader>av", ask("@visible "), desc = "Ask (visible)" },
		{
			"<leader>aD",
			prompt("Add documentation comments to the function at @this. Only document this function, nothing else."),
			desc = "Document function",
		},
		{
			"<leader>as",
			function()
				require("comlink").select()
			end,
			desc = "Select action",
		},
		{
			"<leader>at",
			function()
				require("comlink").toggle()
			end,
			desc = "Toggle agent pane",
		},
		{
			"<leader>af",
			function()
				require("comlink").focus()
			end,
			desc = "Focus agent pane",
		},
		{
			"<leader>ap",
			function()
				require("comlink").pick()
			end,
			desc = "Pick agent pane",
		},
		{
			"<S-C-u>",
			function()
				require("comlink").send_keys("pageup")
			end,
			desc = "Scroll agent up",
		},
		{
			"<S-C-d>",
			function()
				require("comlink").send_keys("pagedown")
			end,
			desc = "Scroll agent down",
		},
	},
}
