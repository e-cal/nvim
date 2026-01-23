return {
	"nickvandyke/opencode.nvim",
    dir ="~/projects/opencode.nvim",
	dependencies = { { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } } },
	config = function()
		local templates = {
			complete = "Follow any instructions in the selected code and complete the functionality:\n\n@this",
			explain = "Explain the following code:\n\n@this",
			yank = "@this\n\n",
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
		}

		vim.o.autoread = true

		local oc = require("opencode")

		vim.keymap.set("x", "<leader>ac", function()
			oc.prompt(templates.complete, { submit = true })
		end, { desc = "Complete from instructions" })

		vim.keymap.set("x", "<leader>aa", function()
			oc.prompt(templates.explain, { submit = true })
		end, { desc = "Ask about selection" })

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

		vim.keymap.set("n", "<leader>aD", function()
			oc.prompt("Add documentation comments to the function at @this. Only document this function, nothing else.", { submit = true })
		end, { desc = "Document function" })

		vim.keymap.set("n", "<leader>aa", function()
			oc.ask("")
		end, { desc = "Ask opencode" })

		vim.keymap.set("n", "<leader>af", function()
			oc.ask("@buffer ")
		end, { desc = "Ask about file" })

		vim.keymap.set("n", "<leader>ab", function()
			oc.ask("@buffers ")
		end, { desc = "Ask about buffers" })

		vim.keymap.set("n", "<leader>aq", function()
			oc.ask("@buffer @quickfix ")
		end, { desc = "Ask about quickfix" })

		vim.keymap.set("n", "<leader>ad", function()
			oc.ask("@diff ")
		end, { desc = "Ask about diff" })

		vim.keymap.set("n", "<leader>ae", function()
			oc.ask("@diagnostics ")
		end, { desc = "Ask about diagnostics" })

		vim.keymap.set("n", "<leader>av", function()
			oc.ask("@visible ")
		end, { desc = "Ask about visible" })

		vim.keymap.set("n", "<leader>as", function()
			oc.select()
		end, { desc = "Select opencode action" })

		vim.keymap.set("n", "<leader>at", function()
			oc.toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set("n", "<S-C-u>", function()
			oc.command("session.half.page.up")
		end, { desc = "Scroll opencode up" })

		vim.keymap.set("n", "<S-C-d>", function()
			oc.command("session.half.page.down")
		end, { desc = "Scroll opencode down" })

		vim.keymap.set("n", "<leader>O", function()
			require("opencode.cli.server")
				.get_port(false)
				:next(function(port)
					vim.notify("Connected to opencode on port " .. port, vim.log.levels.INFO, { title = "opencode" })
					require("opencode.events").subscribe()
				end)
				:catch(function(err)
					vim.notify("No opencode server found in CWD", vim.log.levels.WARN, { title = "opencode" })
				end)
		end, { desc = "Connect to opencode" })
	end,
}
