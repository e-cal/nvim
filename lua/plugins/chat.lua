return {
	"e-cal/chat.nvim",
	dir = "~/projects/chat.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		api_keys = {
			openai = function()
				local f = assert(io.open(os.getenv("HOME") .. "/.cache/oai", "r"))
				local openai_api_key = string.gsub(f:read("*all"), "\n", "")
				f:close()
				return openai_api_key
			end,
            anthropic = function()
                local f = assert(io.open(os.getenv("HOME") .. "/.cache/anthropic", "r"))
                local anthropics_api_key = string.gsub(f:read("*all"), "\n", "")
                f:close()
                return anthropics_api_key
            end,
            groq = function()
                local f = assert(io.open(os.getenv("HOME") .. "/.cache/groq", "r"))
                local groq_api_key = string.gsub(f:read("*all"), "\n", "")
                f:close()
                return groq_api_key
            end,
		},
	},
}
