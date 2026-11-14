return {
	"nvimtools/hydra.nvim",
	config = function()
		local hydra = require("hydra")
		for _, body in ipairs({ "zl", "zh", "zL", "zH" }) do
			hydra({
				body = body,
				name = "scroll",
				mode = "n",
				heads = { { "l", "zl" }, { "h", "zh" }, { "L", "10zl" }, { "H", "10zh" } },
				config = { invoke_on_body = true },
			})
		end
	end,
}
