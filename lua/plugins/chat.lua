return {
	"e-cal/chat.nvim",
	-- dir = "~/projects/chat.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
    lazy = false,
	opts = {
        auto_scroll = false,
        default = {
            model = "sonnet-latest",
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
