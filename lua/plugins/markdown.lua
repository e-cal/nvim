return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown" },
			log_level = "debug",
			preset = "obsidian",
			code = {
				sign = false,
			},
			heading = {
				icons = { " ", " ", " ", " " },
				sign = false,
			},
			bullet = { icons = { "•", "↳", "⟶ ", "⪧" } },
			callout = {
				question = { raw = "[?]", rendered = "󰘥  ", highlight = "RenderMarkdownInfo" },
				note = { raw = "[!note]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
				tip = { raw = "[!tip]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
				important = { raw = "[!important]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
				warning = { raw = "[!warning]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
				caution = { raw = "[!caution]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
				-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
				abstract = { raw = "[!abstraCT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
				summary = { raw = "[!summary]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
				tldr = { raw = "[!tldr]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
				info = { raw = "[!info]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
				todo = { raw = "[!todo]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
				hint = { raw = "[!hint]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
				success = { raw = "[!success]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
				check = { raw = "[!check]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
				done = { raw = "[!done]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
				help = { raw = "[!help]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
				faq = { raw = "[!faq]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
				attention = { raw = "[!attention]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
				failure = { raw = "[!failure]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
				fail = { raw = "[!fail]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
				missing = { raw = "[!missing]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
				danger = { raw = "[!danger]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
				error = { raw = "[!error]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
				bug = { raw = "[!bug]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
				example = { raw = "[!example]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
				quote = { raw = "[!quote]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
				cite = { raw = "[!cite]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
			},
			latex = {
				enabled = false,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
				top_pad = 0,
				bottom_pad = 0,
			},
		},
		ft = { "markdown", "Avante" },
	},
	{
		"jbyuki/nabla.nvim",
		lazy = false,
		keys = {
			-- { "<leader>mP", "<cmd> lua require('nabla').popup()<cr>", desc = "popup math" },
			-- { "<leader>mt", "<cmd> lua require('nabla').toggle_virt()<cr>", desc = "toggle math" },
		},
	},
	-- {
	-- 	"3rd/diagram.nvim",
	-- 	ft = { "markdown", "norg" },
	-- 	dependencies = {
	-- 		"3rd/image.nvim",
	-- 	},
	-- 	opts = function()
	-- 		local browser_candidates = {
	-- 			"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
	-- 			"/Applications/Chromium.app/Contents/MacOS/Chromium",
	-- 			"/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
	-- 			"/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
	-- 		}
	--
	-- 		local browser_path
	-- 		for _, candidate in ipairs(browser_candidates) do
	-- 			if vim.fn.filereadable(candidate) == 1 then
	-- 				browser_path = candidate
	-- 				break
	-- 			end
	-- 		end
	--
	-- 		local mermaid = {}
	-- 		if browser_path then
	-- 			local puppeteer_config = vim.fn.stdpath("cache") .. "/diagram-mermaid-puppeteer.json"
	-- 			vim.fn.writefile({ vim.fn.json_encode({ executablePath = browser_path }) }, puppeteer_config)
	-- 			mermaid.cli_args = { "-p", puppeteer_config }
	-- 		end
	--
	-- 		return {
	-- 			renderer_options = {
	-- 				mermaid = mermaid,
	-- 			},
	-- 		}
	-- 	end,
	-- },
}
