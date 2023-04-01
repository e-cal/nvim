local lualine = require("lualine")
local utils = require("lualine.utils.utils")

local colors = {
	normal = utils.extract_color_from_hllist("fg", { "Label" }, "#ff0000"),
	insert = utils.extract_color_from_hllist("fg", { "String" }, "#ff0000"),
	replace = utils.extract_color_from_hllist("fg", { "Number", "Type" }, "#ff0000"),
	visual = utils.extract_color_from_hllist("fg", { "Special", "Boolean", "Constant" }, "#ff0000"),
	command = utils.extract_color_from_hllist("fg", { "Identifier" }, "#ff0000"),
	-- TODO: make a util function instead of using gross extract_color_from_hllist
	fg = string.format("#%06x", vim.api.nvim_get_hl_by_name("Normal", true).foreground), -- utils.extract_color_from_hllist("fg", { "Normal", "StatusLine" }, "#ff0000"),
	bg = utils.extract_color_from_hllist("bg", { "CursorLine" }, "#ff0000"),
	grey = utils.extract_color_from_hllist("fg", { "Comment" }, "#ff0000"),
}

-- =============================================================================
-- Adding modified colors (brightness)

-- Turns #rrggbb -> { red, green, blue }
local function rgb_str2num(rgb_color_str)
	if rgb_color_str:find("#") == 1 then
		rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
	end
	local red = tonumber(rgb_color_str:sub(1, 2), 16)
	local green = tonumber(rgb_color_str:sub(3, 4), 16)
	local blue = tonumber(rgb_color_str:sub(5, 6), 16)
	return { red = red, green = green, blue = blue }
end

-- Turns { red, green, blue } -> #rrggbb
local function rgb_num2str(rgb_color_num)
	local rgb_color_str = string.format("#%02x%02x%02x", rgb_color_num.red, rgb_color_num.green, rgb_color_num.blue)
	return rgb_color_str
end

-- Clamps the val between left and right
local function clamp(val, left, right)
	if val > right then
		return right
	end
	if val < left then
		return left
	end
	return val
end

-- Changes brightness of rgb_color by percentage
local function brightness_modifier(rgb_color, parcentage)
	local color = rgb_str2num(rgb_color)
	color.red = clamp(color.red + (color.red * parcentage / 100), 0, 255)
	color.green = clamp(color.green + (color.green * parcentage / 100), 0, 255)
	color.blue = clamp(color.blue + (color.blue * parcentage / 100), 0, 255)
	return rgb_num2str(color)
end

colors.bg_bright = brightness_modifier(colors.bg, 40)
-- =============================================================================

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
local function ins_left(component, inactive)
	table.insert(config.sections.lualine_c, component)
	if inactive then
		table.insert(config.inactive_sections.lualine_c, component)
	end
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

local function ins_inactive(component)
	table.insert(config.inactive_sections.lualine_c, component)
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

ins_inactive({
	function()
		return "%="
	end,
})

ins_left({
	function()
		return ""
	end,
	color = { fg = colors.bg_bright, bg = colors.bg },
	padding = { left = 0, right = 0 },
}, true)

ins_left({
	"filetype",
	icon_only = true,
	color = { fg = colors.fg, bg = colors.bg_bright },
	padding = { left = 0, right = 1 },
}, true)

local function get_filename()
	local fg = colors.fg -- not modified
	if vim.bo.modified then
		fg = colors.command -- unsaved
	elseif not vim.bo.modifiable then
		fg = colors.replace -- readonly
	end
	vim.cmd("hi! lualine_filename_status gui=bold guibg=" .. colors.bg_bright .. " guifg=" .. fg)

	return "%t"
end

ins_left({
	get_filename,
	cond = conditions.buffer_not_empty,
	color = "lualine_filename_status",
	padding = { left = 0, right = 0 },
})

ins_inactive({
	get_filename,
	cond = conditions.buffer_not_empty,
	color = {
		fg = brightness_modifier(colors.fg, -30),
		bg = colors.bg_bright,
	},
	padding = { left = 0, right = 0 },
})

ins_left({
	function()
		return ""
	end,
	color = { fg = colors.bg_bright, bg = colors.bg },
	padding = { left = 0, right = 0 },
}, true)

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
		local msg = "No LSP"
		local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then
			return msg
		end
		local msg = ""
		for _, client in ipairs(clients) do
			-- local filetypes = client.config.filetypes
			-- if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			-- return client.name
			-- end
			if msg == "" then
				msg = client.name
			else
				msg = msg .. "/" .. client.name
			end
		end
		return msg
	end,
	icon = " ",
	color = { fg = colors.grey },
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		local line = vim.fn.line(".")
		local col = vim.fn.virtcol(".")
		return string.format(" %d:%-2d", line, col)
	end,
	color = { fg = colors.fg },
})

ins_right({
	function()
		local cur = vim.fn.line(".")
		local total = vim.fn.line("$")
		if cur == 1 then
			return "  ﬢ "
		elseif cur == total then
			return "   ﬠ "
		else
			return "(" .. math.floor(cur / total * 100) .. "%%)"
		end
	end,
	color = { fg = colors.grey },
})

lualine.setup(config)
