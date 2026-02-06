return {
	"nickvandyke/opencode.nvim",
	dir = "~/projects/opencode.nvim",
	dependencies = { { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } } },
	config = function()
		local templates = {
			complete = "Follow any instructions in the selected code and complete the functionality:\n\n@code",
			explain = "Explain the following code:\n\n@code",
			yank = "@code\n\n",
		}

		---@type opencode.Opts
		vim.g.opencode_opts = {
			provider = {
				enabled = "tmux",
				tmux = {
					options = "-h",
					auto_close = false,
				},
			},
			events = {
				enabled = true,
				reload = true,
				permissions = { enabled = false },
			},
			contexts = {
				["@code"] = function(ctx)
					local buf = ctx.buf
					local ref = ctx:this()
					local ft = vim.bo[buf].filetype
					local code
					if ctx.range then
						-- Visual selection or operator range
						local from, to = ctx.range.from, ctx.range.to
						if ctx.range.kind == "line" then
							local lines = vim.api.nvim_buf_get_lines(buf, from[1] - 1, to[1], false)
							code = table.concat(lines, "\n")
						else
							local text = vim.api.nvim_buf_get_text(buf, from[1] - 1, from[2], to[1] - 1, to[2] + 1, {})
							code = table.concat(text, "\n")
						end
					else
						-- Current line from cursor position
						code = vim.api.nvim_buf_get_lines(buf, ctx.cursor[1] - 1, ctx.cursor[1], false)[1]
					end
					return ref .. "\n```" .. ft .. "\n" .. code .. "\n```"
				end,
			},
		}

		vim.o.autoread = true
	end,
	keys = {
		-- Visual mode
		{
			"<leader>ac",
			function()
				require("opencode").prompt(
					"Follow any instructions in the selected code and complete the functionality:\n\n@code",
					{ submit = true }
				)
			end,
			mode = "x",
			desc = "Complete",
		},
		{
			"<leader>aa",
			function()
				local oc = require("opencode")
				local ctx = require("opencode.context").new()
				vim.ui.input({ prompt = "Ask: " }, function(input)
					if input and input ~= "" then
						oc.prompt(input .. "\n\n@code", { context = ctx, submit = true })
					else
						ctx:resume()
					end
				end)
			end,
			mode = "x",
			desc = "Ask (selection)",
		},
		{
			"<leader>ae",
			function()
				require("opencode").prompt("Explain the following code:\n\n@code", { submit = true })
			end,
			mode = "x",
			desc = "Explain selection",
		},
		{
			"<leader>ay",
			function()
				require("opencode").ask("@code\n\n")
			end,
			mode = "x",
			desc = "Yank to prompt",
		},
		{
			"<leader>ar",
			function()
				require("opencode").prompt("Review @this for correctness and readability", { submit = true })
			end,
			mode = "x",
			desc = "Review selection",
		},
		{
			"<leader>at",
			function()
				require("opencode").prompt("Add tests for @this", { submit = true })
			end,
			mode = "x",
			desc = "Generate tests",
		},
		{
			"<leader>ao",
			function()
				require("opencode").prompt("Optimize @this for performance and readability", { submit = true })
			end,
			mode = "x",
			desc = "Optimize selection",
		},
		{
			"<leader>aD",
			function()
				require("opencode").prompt(
					"Add documentation comments to @this. Only document this code, nothing else.",
					{ submit = true }
				)
			end,
			mode = "x",
			desc = "Document selection",
		},

		-- Normal mode
		{
			"<leader>aD",
			function()
				require("opencode").prompt(
					"Add documentation comments to the function at @this. Only document this function, nothing else.",
					{ submit = true }
				)
			end,
			desc = "Document function",
		},
		{
			"<leader>aa",
			function()
				require("opencode").ask("", { submit = true })
			end,
			desc = "Ask",
		},
		{
			"<leader>ah",
			function()
				require("opencode").ask("")
			end,
			desc = "Ask (here)",
		},
		{
			"<leader>af",
			function()
				require("opencode").ask("@buffer ")
			end,
			desc = "Ask (file)",
		},
		{
			"<leader>ab",
			function()
				require("opencode").ask("@buffers ")
			end,
			desc = "Ask (buffers)",
		},
		{
			"<leader>aq",
			function()
				require("opencode").ask("@buffer @quickfix ")
			end,
			desc = "Ask (quickfix)",
		},
		{
			"<leader>ad",
			function()
				require("opencode").ask("@diff ")
			end,
			desc = "Ask (diff)",
		},
		{
			"<leader>ae",
			function()
				require("opencode").ask("@diagnostics ")
			end,
			desc = "Ask (diagnostics)",
		},
		{
			"<leader>av",
			function()
				require("opencode").ask("@visible ")
			end,
			desc = "Ask (visible)",
		},
		{
			"<leader>as",
			function()
				require("opencode").select()
			end,
			desc = "Select action",
		},
		{
			"<leader>at",
			function()
				require("opencode").toggle()
			end,
			desc = "Toggle",
		},
		{
			"<S-C-u>",
			function()
				require("opencode").command("session.half.page.up")
			end,
			desc = "Scroll up",
		},
		{
			"<S-C-d>",
			function()
				require("opencode").command("session.half.page.down")
			end,
			desc = "Scroll down",
		},

		{
			"<leader>O",
			function()
				local oc = require("opencode")
				require("opencode.cli.server")
					.get_port(false)
					:next(function(port)
						vim.notify(
							"Connected to opencode on port " .. port,
							vim.log.levels.INFO,
							{ title = "opencode" }
						)
						require("opencode.events").subscribe()
					end)
					:catch(function(err)
						vim.notify("Starting opencode...", vim.log.levels.INFO, { title = "opencode" })
						oc.start()
					end)
			end,
			desc = "Connect",
		},
	},
}
