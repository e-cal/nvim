return {
	"e-cal/opencode.nvim",
	dir = "~/projects/opencode.nvim",
	-- "NickvanDyke/opencode.nvim",
	dependencies = { { "folke/snacks.nvim", opts = { input = { enabled = true } } } },
	-- opts = {},
	keys = {
		--[[
        @buffer         Current buffer
        @buffers        Open buffers
        @cursor         Cursor position
        @selection      Selected text
        @visible        Visible text
        @diagnostic     Current line diagnostics
        @diagnostics    Current buffer diagnostics
        @quickfix       Quickfix list
        @diff           Git diff
        @grapple        grapple.nvim tags
        ]]
        -- stylua: ignore start
        { "<leader>aa", function()
            local file = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':~:.')
            require("opencode").ask("@" .. file .. " ")
        end, desc = "ask" },
		{ "<leader>a<cr>", function() require("opencode").ask("@grapple ") end, desc = "message w/ context (grapple)", mode = "n" },
		{ "<leader>at", function() require("opencode").toggle() end, desc = "toggle" },
		{ "<leader>ae", function() require("opencode").prompt("Explain @cursor and its context") end, desc = "Explain code near cursor" },
		{ "<leader>an", function() require("opencode").command("session_new") end, desc = "New session" },
		{ "<leader>ay", function() require("opencode").command("messages_copy") end, desc = "Copy last message" },
		{ "<leader>ap", function() require("opencode").select_prompt() end, desc = "Select prompt", mode = { "n", "v" } },
		{ "<leader>aa", function() require("opencode").ask("@selection: ") end, desc = "Ask opencode about selection", mode = "v" },
        { "<S-C-u>", function() require("opencode").command("messages_half_page_up") end, desc = "Scroll messages up" },
		{ "<S-C-d>", function() require("opencode").command("messages_half_page_down") end, desc = "Scroll messages down" },
		-- stylua: ignore end
	},
	init = function()
		vim.api.nvim_create_user_command("OpencodeConnect", function()
			local ok, err = pcall(function()
				local cfg = require("opencode.config")
				local opts = cfg.opts
				local s_port = vim.g.__opencode_sse_port
				require("opencode.server").get_port(function(ok, res)
					if not ok then
						vim.notify(res, vim.log.levels.ERROR, { title = "opencode" })
						return
					end
					if opts.auto_reload then
						require("opencode.reload").setup()
					end
					if res ~= s_port then
						require("opencode.client").listen_to_sse(res, function(r)
							vim.api.nvim_exec_autocmds("User", { pattern = "OpencodeEvent", data = r })
						end)
						vim.g.__opencode_sse_port = res
					end
				end)
			end)
			if not ok then
				vim.notify(err, vim.log.levels.ERROR, { title = "opencode" })
			end
		end, {})
	end,
}
