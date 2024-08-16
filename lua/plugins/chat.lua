return {
	"e-cal/chat.nvim",
	dir = "~/projects/chat.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
    lazy = false,
	opts = {
        auto_scroll = false,
		api_keys = {
			openai = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/oai", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
			anthropic = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/anthropic", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
			deepseek = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/deepseek", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
			groq = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/groq", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
			fireworks = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/fireworks", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
			topology = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/clm-default", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
			openrouter = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/openrouter", "r"))
				local api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return api_key
			end,
		},
	},
	keys = {
		{ "<leader>cc", "<cmd>ChatFocus<cr>", desc = "focus" },
		{ "<leader>ci", "<cmd>ChatInline<cr>", desc = "inline" },
		{ "<leader>cr", "<cmd>ChatInline replace<cr>", desc = "replace inline" },
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
		{ "<leader>cr", "<cmd>ChatInline replace<cr>", desc = "replace inline", mode = "v" },
	},
}
