return {
	"Exafunction/windsurf.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({})
	end,
}

-- return {
-- 	{
-- 		"copilotlsp-nvim/copilot-lsp",
-- 		init = function()
-- 			vim.g.copilot_nes_debounce = 500
-- 			vim.lsp.enable("copilot_ls")
--
-- 			vim.keymap.set("n", "<tab>", function()
-- 				local bufnr = vim.api.nvim_get_current_buf()
-- 				local state = vim.b[bufnr].nes_state
-- 				if state then
-- 					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
-- 						or (
-- 							require("copilot-lsp.nes").apply_pending_nes()
-- 							and require("copilot-lsp.nes").walk_cursor_end_edit()
-- 						)
-- 					return nil
-- 				else
-- 					-- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
-- 					return "<C-i>"
-- 				end
-- 			end, { desc = "Accept Copilot NES suggestion", expr = true })
-- 			vim.keymap.set("i", "<C-j>", function()
-- 				local bufnr = vim.api.nvim_get_current_buf()
-- 				local state = vim.b[bufnr].nes_state
-- 				if state then
-- 					-- Try to jump to the start of the suggestion edit.
-- 					local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
-- 						-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
-- 						or (
-- 							require("copilot-lsp.nes").apply_pending_nes()
-- 							and require("copilot-lsp.nes").walk_cursor_end_edit()
-- 						)
-- 					return nil
-- 				end
-- 			end, { desc = "Accept Copilot NES suggestion", expr = true })
--
-- 			vim.keymap.set("n", "<esc>", function()
-- 				if not require("copilot-lsp.nes").clear() then
-- 					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", false)
-- 				end
-- 			end, { desc = "Clear Copilot suggestion or fallback" })
-- 		end,
-- 	},
-- 	{
-- 		"zbirenbaum/copilot.lua",
-- 		dependencies = { "copilotlsp-nvim/copilot-lsp" },
-- 		cmd = "Copilot",
-- 		event = "InsertEnter",
-- 		config = function()
-- 			require("copilot").setup({
-- 				suggestion = {
-- 					enabled = true,
-- 					auto_trigger = true,
-- 					hide_during_completion = false,
-- 					trigger_on_accept = true,
-- 					keymap = {
-- 						accept = "<C-j>",
-- 						accept_word = "<C-S-j>",
-- 						accept_line = "<right>",
-- 						next = "<C-k>",
-- 						prev = "<C-l>",
-- 						-- dismiss = "<C-h>",
-- 					},
-- 				},
-- 				nes = {
-- 					enabled = false,
-- 					auto_trigger = false,
-- 					keymap = {
-- 						accept_and_goto = false,
-- 						accept = false,
-- 						dismiss = false,
-- 					},
-- 				},
-- 				panel = {
-- 					enabled = true,
-- 					auto_refresh = true,
-- 				},
-- 			})
-- 		end,
-- 	},
-- 	-- {
-- 	-- 	"zbirenbaum/copilot-cmp",
-- 	-- 	config = function()
-- 	-- 		require("copilot_cmp").setup()
-- 	-- 	end,
-- 	-- },
-- 	-- { "github/copilot.vim" },
-- }
