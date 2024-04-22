return {
	"e-cal/chat.nvim",
	-- dir = "~/projects/chat.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		openai_api_key = function()
			local f = assert(io.open(os.getenv("HOME") .. "/.cache/oai", "r"))
			local openai_api_key = string.gsub(f:read("*all"), "\n", "")
			f:close()
			return openai_api_key
		end,
	},
}
