local lualine = require("lualine")
local utils = require("lualine.utils.utils")

local colors = {
	normal = utils.extract_color_from_hllist("fg", { "Label" }, "#000000"),
	insert = utils.extract_color_from_hllist("fg", { "String" }, "#000000"),
	replace = utils.extract_color_from_hllist("fg", { "Number", "Type" }, "#000000"),
	visual = utils.extract_color_from_hllist("fg", { "Special", "Boolean", "Constant" }, "#000000"),
	command = utils.extract_color_from_hllist("fg", { "Identifier" }, "#000000"),
	bg = utils.extract_color_from_hllist("bg", { "Normal", "StatusLineNC" }, "#000000"),
	fg = utils.extract_color_from_hllist("fg", { "Normal", "StatusLine" }, "#000000"),
	bg2 = utils.extract_color_from_hllist("bg", { "CursorLine" }, "#000000"),
	grey = "#666666",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
			-- We are going to use lualine_c an lualine_x as left and
			-- right section. Both are highlighted by c theme .  So we
			-- are just setting default looks o statusline
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊"
	end,
	color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.normal, -- normal
			no = colors.command, -- op pending
			v = colors.visual, -- visual
			V = colors.visual, -- visual line
			[""] = colors.visual, -- visual block
			s = colors.visual, -- select
			S = colors.visual, -- select line
			[""] = colors.visual, -- select block
			i = colors.insert, -- insert
			ic = colors.command, -- insert completion
			R = colors.replace, -- replace
			Rv = colors.replace, -- virtual replace
			c = colors.command, -- command editing
			cv = colors.visual, -- ex (Q) mode
			ce = colors.visual, -- normal ex mode
			r = colors.normal, -- enter prompt
			rm = colors.normal, -- more prompt
			["r?"] = colors.normal, -- confirm query
			["!"] = colors.command, -- shell command executing
			t = colors.command, -- terminal
		}
		return { fg = mode_color[vim.fn.mode()] }
	end,
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	function()
		return ""
	end,
	color = { fg = colors.bg2, bg = colors.bg },
	padding = { left = 0, right = 0 },
})

ins_left({
	"filetype",
	icon_only = true,
	color = { fg = colors.fg, bg = colors.bg2 },
	padding = { left = 0, right = 1 },
})

ins_left({
	function()
		local fg = colors.fg -- not modified
		if vim.bo.modified then
			fg = colors.command -- unsaved
		elseif not vim.bo.modifiable then
			fg = colors.replace -- readonly
		end
		vim.cmd("hi! lualine_filename_status gui=bold guibg=" .. colors.bg2 .. " guifg=" .. fg)

		return "%t"
	end,
	cond = conditions.buffer_not_empty,
	color = "lualine_filename_status",
	padding = { left = 0, right = 0 },
})

ins_left({
	function()
		return ""
	end,
	color = { fg = colors.bg2, bg = colors.bg },
	padding = { left = 0, right = 0 },
})

--[[
ins_right({
	"branch",
	icon = "",
	color = { fg = colors.violet, gui = "bold" },
})
]]
ins_left({
	"branch",
	icon = { "", color = { fg = colors.replace } },
	color = { fg = colors.fg },
	cond = conditions.hide_in_width,
})

--[[
ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = "柳 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})
]]
ins_left({
	"diff",
	cond = conditions.hide_in_width,
})

--[[
-- Insert mid section
ins_left({
	function()
		return "%="
	end,
})
]]
ins_right({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	-- diagnostics_color = {
	-- 	color_error = { fg = colors.red },
	-- 	color_warn = { fg = colors.yellow },
	-- 	color_info = { fg = colors.cyan },
	-- },
	cond = conditions.hide_in_width,
})

ins_right({
	-- Lsp server name .
	function()
		local msg = "No Active Lsp"
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return msg
		end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = " ",
	color = { fg = colors.grey },
	cond = conditions.hide_in_width,
})

ins_right({
	"location",
	icon = "",
	color = { fg = colors.fg },
})

ins_right({
	function()
		local cur = vim.fn.line(".")
		local total = vim.fn.line("$")
		if cur == 1 then
			return "ﬢ"
		elseif cur == total then
			return "ﬠ"
		else
			return "(" .. math.floor(cur / total * 100) .. "%%)"
		end
	end,
	color = { fg = colors.grey },
})

lualine.setup(config)
