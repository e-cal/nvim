local lualine = require("lualine")

-- =============================================================================
local colors = {
	normal = Utils.get_hl("Label", "fg"),
	insert = Utils.get_hl("String", "fg"),
	replace = Utils.get_hl("Number", "fg"),
	visual = Utils.get_hl("Special", "fg"),
	command = Utils.get_hl("Identifier", "fg"),
	red = Utils.get_hl("Error", "fg"),
	yellow = Utils.get_hl("WarningMsg", "fg"),
	fg = Utils.get_hl("Normal", "fg"),
	bg = Utils.brightness_modifier(Utils.get_hl("Normal", "bg"), 20),
}

colors.bg_bright = Utils.brightness_modifier(colors.bg, 30)
colors.bg_dark = Utils.brightness_modifier(colors.bg, -10)
colors.fg_dark = Utils.brightness_modifier(colors.fg, -50)
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
	py_file = function()
		return vim.bo.filetype == "python"
	end,
	_and = function(a, b)
		return function()
			return a() and b()
		end
	end,
}

local config = {
	options = {
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = {
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
		return "█"
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

-- TODO: could be baked into above i think
ins_inactive({
	get_filename,
	cond = conditions.buffer_not_empty,
	color = {
		fg = colors.fg_dark,
		bg = colors.bg_bright,
	},
	padding = { left = 0, right = 0 },
})

ins_left({
	function()
		return "█"
	end,
	color = { fg = colors.bg_bright, bg = colors.bg },
	padding = { left = 0, right = 0 },
}, true)

ins_left({
	"branch",
	icon = {
		"",
		-- color = { fg = colors.replace },
	},
	color = { fg = colors.fg_dark },
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
			if client.name == "null-ls" then
				goto continue
			end
			if msg == "" then
				msg = client.name
			else
				msg = msg .. " + " .. client.name
			end
			::continue::
		end
		return msg
	end,
	icon = "󱁤",
	color = { fg = colors.fg_dark },
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		local env = vim.env.VIRTUAL_ENV
		if env ~= nil then
			return "" .. env:match(".*/(.*)") .. ")"
		end
		return ""
	end,
	color = { fg = colors.fg_dark },
	icon = "(󰆧",
	cond = conditions._and(conditions.hide_in_width, conditions.py_file),
})

ins_right({
	function()
		return ""
	end,
	color = { fg = colors.insert },
	padding = { left = 0, right = 0 },
	cond = conditions.hide_in_width,
})

-- dumb folder icon needs a lot of symbols to look good
-- ins_right({
-- 	function()
-- 		return " "
-- 	end,
-- 	color = { fg = colors.bg_bright, bg = colors.insert },
-- 	padding = { left = 0, right = 0 },
-- 	cond = conditions.hide_in_width,
-- })

ins_right({
	function()
		return vim.fn.getcwd():match("^.*/(.*)")
	end,
	icon = { " ", color = { fg = colors.bg_bright, bg = colors.insert } },
	color = { fg = colors.insert, bg = colors.bg_bright },
	cond = conditions.hide_in_width,
	padding = { left = 0, right = 1 },
})

--[[
ins_right({
	function()
		local line = vim.fn.line(".")
		local col = vim.fn.virtcol(".")
		return string.format(" %d:%-2d", line, col)
	end,
	color = { fg = colors.fg },
})
]]
ins_right({
	function()
		return ""
	end,
	color = { fg = colors.normal, bg = colors.bg_bright },
	padding = { left = 0, right = 0 },
})
ins_right({
	function()
		local cur = vim.fn.line(".")
		local total = vim.fn.line("$")
		-- if cur == 1 then
		-- 	return "   ﬢ "
		-- elseif cur == total then
		-- 	return "   ﬠ "
		-- else
		-- 	return string.format("%2d%%%%", math.floor(cur / total * 100))
		-- end
		return string.format("%2d%%%%", math.floor(cur / total * 100))
	end,
	icon = { " ", color = { fg = colors.bg_bright, bg = colors.normal } },
	color = { fg = colors.normal, bg = colors.bg_bright },
	padding = { left = 0, right = 1 },
})

lualine.setup(config)
