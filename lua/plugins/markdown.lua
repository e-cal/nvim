return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>PreviewDoc<cr>", desc = "toggle preview" },
			{ "<leader>ms", "1z=", desc = "fix spelling" },
			{ "<leader>mz", "mz<cmd>CleanText<cr>'z", desc = "clean text" },
			{ "<leader>mc", "<cmd>silent !md2pdf %<cr>", desc = "compile" },
		},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		opts = {
			workspaces = { { name = "notes", path = "~/notes" } },
			completion = { nvim_cmp = true, min_chars = 0 },
			ui = { enable = false },
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
			log_level = "debug",

			preset = "obsidian",
			code = {
				sign = false,
			},
			latex = {
				enabled = true,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
				top_pad = 0,
				bottom_pad = 0,
			},
			bullet = { icons = { "•", "↳", "⟶ ", "⪧" } },
			callout = {
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
				question = { raw = "[!question]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
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
		},
		ft = { "markdown", "Avante" },
	},
	{
		"jbyuki/nabla.nvim",
		lazy = false,
		keys = {
			{ "<leader>mP", "<cmd> lua require('nabla').popup()<cr>", desc = "popup math" },
			{ "<leader>mt", "<cmd> lua require('nabla').toggle_virt()<cr>", desc = "toggle math" },
		},
	},
}
