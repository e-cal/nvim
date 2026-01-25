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
				},
			},
			events = {
				enabled = true,
				reload = true,
				permissions = {
					enabled = false,
				},
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

		local oc = require("opencode")

		------------
		-- Visual --
		------------
		vim.keymap.set("x", "<leader>ac", function()
			oc.prompt(templates.complete, { submit = true })
		end, { desc = "Complete" })

		vim.keymap.set("x", "<leader>aa", function()
			local ctx = require("opencode.context").new()
			vim.ui.input({ prompt = "Ask: " }, function(input)
				if input and input ~= "" then
					oc.prompt(input .. "\n\n@code", { context = ctx })
				else
					ctx:resume()
				end
			end)
		end, { desc = "Ask (selection)" })

		vim.keymap.set("x", "<leader>ae", function()
			oc.prompt(templates.explain, { submit = true })
		end, { desc = "Explain selection" })

		vim.keymap.set("x", "<leader>ay", function()
			oc.ask(templates.yank)
		end, { desc = "Yank to prompt" })

		vim.keymap.set("x", "<leader>ar", function()
			oc.prompt("Review @this for correctness and readability", { submit = true })
		end, { desc = "Review selection" })

		vim.keymap.set("x", "<leader>at", function()
			oc.prompt("Add tests for @this", { submit = true })
		end, { desc = "Generate tests" })

		vim.keymap.set("x", "<leader>ao", function()
			oc.prompt("Optimize @this for performance and readability", { submit = true })
		end, { desc = "Optimize selection" })

		vim.keymap.set("x", "<leader>aD", function()
			oc.prompt("Add documentation comments to @this. Only document this code, nothing else.", { submit = true })
		end, { desc = "Document selection" })

		------------
		-- Normal --
		------------
		vim.keymap.set("n", "<leader>aD", function()
			oc.prompt(
				"Add documentation comments to the function at @this. Only document this function, nothing else.",
				{ submit = true }
			)
		end, { desc = "Document function" })

		vim.keymap.set("n", "<leader>aa", function()
			oc.ask("")
		end, { desc = "Ask" })

		vim.keymap.set("n", "<leader>ah", function()
			oc.ask("")
		end, { desc = "Ask (here)" })

		vim.keymap.set("n", "<leader>af", function()
			oc.ask("@buffer ")
		end, { desc = "Ask (file)" })

		vim.keymap.set("n", "<leader>ab", function()
			oc.ask("@buffers ")
		end, { desc = "Ask (buffers)" })

		vim.keymap.set("n", "<leader>aq", function()
			oc.ask("@buffer @quickfix ")
		end, { desc = "Ask (quickfix)" })

		vim.keymap.set("n", "<leader>ad", function()
			oc.ask("@diff ")
		end, { desc = "Ask (diff)" })

		vim.keymap.set("n", "<leader>ae", function()
			oc.ask("@diagnostics ")
		end, { desc = "Ask (diagnostics)" })

		vim.keymap.set("n", "<leader>av", function()
			oc.ask("@visible ")
		end, { desc = "Ask (visible)" })

		vim.keymap.set("n", "<leader>as", function()
			oc.select()
		end, { desc = "Select action" })

		vim.keymap.set("n", "<leader>at", function()
			oc.toggle()
		end, { desc = "Toggle" })

		vim.keymap.set("n", "<S-C-u>", function()
			oc.command("session.half.page.up")
		end, { desc = "Scroll up" })

		vim.keymap.set("n", "<S-C-d>", function()
			oc.command("session.half.page.down")
		end, { desc = "Scroll down" })

		vim.keymap.set("n", "<leader>O", function()
			require("opencode.cli.server")
				.get_port(false)
				:next(function(port)
					vim.notify("Connected to opencode on port " .. port, vim.log.levels.INFO, { title = "opencode" })
					require("opencode.events").subscribe()
				end)
				:catch(function(err)
					vim.notify("Starting opencode...", vim.log.levels.INFO, { title = "opencode" })
					oc.start()
				end)
		end, { desc = "Connect" })
	end,
}
