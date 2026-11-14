return {
	"e-cal/chat.nvim",
	dir = (function()
		local path = vim.fn.expand("~/projects/chat.nvim")
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
		return nil
	end)(),
	lazy = false,
	opts = {
		model = "sonnet",
		inline_model = "sonnet",
	},
	keys = {
		{ "<leader>cc", "<cmd>Chat focus<cr>", desc = "focus", mode = { "n", "x" } },
		{ "<leader>ci", "<cmd>Chat inline<cr>", desc = "inline", mode = { "n", "x" } },
		{ "<leader>c1", "<cmd>Chat inline gpt<cr>", desc = "inline (gpt)", mode = { "n", "x" } },
		{ "<leader>cr", "<cmd>Chat replace<cr>", desc = "replace selection", mode = "x" },
		{ "<leader>cs", "<cmd>Chat stop<cr>", desc = "stop reply" },
		{ "<leader>cn", "<cmd>Chat new<cr>", desc = "new chat" },
		{ "<leader>co", "<cmd>Chat open<cr>", desc = "open chat" },
		{ "<leader>cO", "<cmd>Chat open float<cr>", desc = "open chat in float" },
		{ "<leader>ct", "<cmd>Chat toggle<cr>", desc = "toggle chat" },
		{ "<leader>ch", "<cmd>Chat resize 50<cr>", desc = "half screen" },
		{ "<leader>cR", "<cmd>Chat resize 30<cr>", desc = "restore size" },
		{ "<leader>cd", "<cmd>Chat delete<cr>", desc = "delete chat" },
		{ "<leader>cf", "<cmd>Chat autoformat<cr>", desc = "toggle formatting" },
		{ "<leader>cp", '"cp', desc = "paste code block", mode = { "n", "x" } },
		{ "<leader>cA", "<cmd>Chat auth<cr>", desc = "auth status" },
	},
}
