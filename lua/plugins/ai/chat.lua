return {
	"e-cal/chat.nvim",
	dir = (function()
		local path = vim.fn.expand("~/projects/chat.nvim")
		if vim.fn.isdirectory(path) == 1 then
			return path
		end
		return nil
	end)(),
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
    lazy = false,
	opts = {
        auto_scroll = false,
        defaults = {
            model = "sonnet-latest",
        },
        providers = {
            opencode = {
                ["opus"] = "claude-opus-4-5",
                ["sonnet-latest"] = "claude-sonnet-4-5",
                ["minimax"] = "minimax-m2.1-free",
                ["glm"] = "glm-4.7-free",
                ["kimi"] = "kimi-k2.5-free",
                ["gpt-5.2"] = "gpt-5.2",
                ["codex"] = "gpt-5.2-codex",
                ["codex-mini"] = "gpt-5.1-codex-mini",
            }
        },
	},
	keys = {
		{ "<leader>cc", "<cmd>ChatFocus<cr>", desc = "focus" },
		{ "<leader>ci", "<cmd>ChatInline<cr>", desc = "inline" },
		{ "<leader>cb", "<cmd>ChatInline base<cr>", desc = "inline (base)" },
		{ "<leader>c1", "<cmd>ChatInline o1<cr>", desc = "inline o1" },
		{ "<leader>cn", "<cmd>ChatNew<cr>", desc = "new chat" },
		{ "<leader>co", "<cmd>ChatOpen<cr>", desc = "open chat" },
		{ "<leader>cO", "<cmd>ChatOpen popup<cr>", desc = "open popup" },
		{ "<leader>ct", "<cmd>ChatToggle<cr>", desc = "toggle chat" },
		{ "<leader>ch", "<cmd>ChatResize 50<cr>", desc = "half screen" },
		{ "<leader>cR", "<cmd>ChatResize 30<cr>", desc = "restore size" },
		{ "<leader>cd", "<cmd>ChatDelete<cr>", desc = "delete chat" },
		{ "<leader>cf", "<cmd>ChatToggleFormatting<cr>", desc = "toggle formatting"},
        { "<C-c>", "<cmd>ChatStop<cr>", desc = "stop generation" },
        -- visual
		{ "<leader>cc", "<cmd>ChatFocus<cr>", desc = "focus", mode = "v" },
		{ "<leader>ci", "<cmd>ChatInline<cr>", desc = "inline", mode = "v" },
		{ "<leader>cb", "<cmd>ChatInline base<cr>", desc = "inline (base)", mode = "v" },
		{ "<leader>cr", "<cmd>ChatReplace<cr>", desc = "replace inline", mode = "v" },
	},
}
