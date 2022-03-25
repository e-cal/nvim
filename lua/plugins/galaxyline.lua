local gl = require("galaxyline")
local colors = {
	black = "#242a32",
	red = "#d54e53",
	green = "#98c379",
	yellow = "#e5c07b",
	orange = "#f4852b",
	blue = "#83a598",
	purple = "#c678dd",
	teal = "#70c0ba",
	white = "#eaeaea",
	grey = "#666666",
	bright_red = "#ec3e45",
	bright_green = "#90c966",
	bright_yellow = "#edbf69",
	bright_blue = "#73ba9f",
	bright_purple = "#c858e9",
	bright_teal = "#2bcec2",
	bright_white = "#ffffff",
	lightbg = "#343C46",
	darkfg = "#A9A18C",
	bg = "#23282F",
	fg = "#ebdbb2",
}
local condition = require("galaxyline.condition")
local gls = gl.section
gl.short_line_list = { "NvimTree", "vista", "dbui", "packer" }

gls.left[1] = {
	ViMode = {
		provider = function()
			-- auto change color according the vim mode
			local mode_color = {
				n = colors.bright_blue, -- normal
				no = colors.blue, -- op pending
				v = colors.purple, -- visual
				V = colors.purple, -- visual line
				[""] = colors.purple, -- visual block
				s = colors.orange, -- select
				S = colors.orange, -- select line
				[""] = colors.orange, -- select block
				i = colors.bright_green, -- insert
				ic = colors.yellow, -- insert completion
				R = colors.red, -- replace
				Rv = colors.red, -- virtual replace
				c = colors.yellow, -- command editing
				cv = colors.blue, -- ex (Q) mode
				ce = colors.blue, -- normal ex mode
				r = colors.cyan, -- enter prompt
				rm = colors.cyan, -- more prompt
				["r?"] = colors.cyan, -- confirm query
				["!"] = colors.blue, -- shell command executing
				t = colors.blue, -- terminal
			}
			vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()])
			return "▊ "
		end,
		highlight = { colors.fg, colors.bg },
	},
}

gls.left[2] = {
	leftSemi = {
		provider = function()
			return ""
		end,
		condition = condition.buffer_not_empty,
		highlight = { colors.lightbg, colors.bg },
	},
}

gls.left[3] = {
	FileIcon = {
		provider = "FileIcon",
		condition = condition.buffer_not_empty,
		highlight = {
			require("galaxyline.provider_fileinfo").get_file_icon_color,
			colors.lightbg,
		},
	},
}

gls.left[4] = {
	FileName = {
		-- provider = "FileName",
		provider = function()
			return vim.fn.expand("%:t")
		end,
		condition = condition.buffer_not_empty,
		highlight = { colors.fg, colors.lightbg },
	},
}

gls.left[5] = {
	rightSemi = {
		provider = function()
			return ""
		end,
		condition = condition.buffer_not_empty,
		highlight = { colors.lightbg, colors.bg },
		separator = " ",
		separator_highlight = { colors.bg, colors.bg },
	},
}

gls.left[6] = {
	GitIcon = {
		provider = function()
			return " "
		end,
		condition = condition.check_git_workspace,
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.orange, colors.bg },
	},
}

gls.left[7] = {
	GitBranch = {
		provider = "GitBranch",
		condition = condition.check_git_workspace,
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.fg, colors.bg },
	},
}

gls.left[8] = {
	DiffAdd = {
		provider = "DiffAdd",
		icon = " ",
		highlight = { colors.green, colors.bg },
	},
}
gls.left[9] = {
	DiffModified = {
		provider = "DiffModified",
		icon = " ﰣ",
		highlight = { colors.yellow, colors.bg },
	},
}
gls.left[10] = {
	DiffRemove = {
		provider = "DiffRemove",
		icon = " ",
		highlight = { colors.red, colors.bg },
	},
}

gls.right[1] = {
	DiagnosticError = {
		provider = "DiagnosticError",
		icon = "  ",
		highlight = { colors.bright_red, colors.bg },
	},
}

gls.right[2] = {
	DiagnosticWarn = {
		provider = "DiagnosticWarn",
		icon = "  ",
		highlight = { colors.orange, colors.bg },
	},
}

gls.right[3] = {
	DiagnosticHint = {
		provider = "DiagnosticHint",
		icon = "  ",
		highlight = { colors.bright_blue, colors.bg },
	},
}

gls.right[4] = {
	DiagnosticInfo = {
		provider = "DiagnosticInfo",
		icon = "  ",
		highlight = { colors.bright_yellow, colors.bg },
	},
}

local get_lsp_client = function(msg)
	msg = msg or "LSP Inactive"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return msg
	end
	local lsps = ""
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			if lsps == "" then
				lsps = client.name
			else
				if not string.find(lsps, client.name) then
					lsps = lsps .. "," .. client.name
				end
			end
		end
	end
	if lsps == "" then
		return msg
	else
		return lsps
	end
end

gls.right[5] = {
	ShowLspClient = {
		-- provider = "GetLspClient",
		provider = get_lsp_client,
		condition = function()
			local tbl = { ["dashboard"] = true, [" "] = true }
			if tbl[vim.bo.filetype] then
				return false
			end
			return condition.hide_in_width()
		end,
		icon = " ",
		separator = " ",
		separator_highlight = { colors.bg, colors.bg },
		highlight = { colors.grey, colors.bg },
	},
}

gls.right[6] = {
	LineInfo = {
		provider = {
			function()
				return string.format("%s:%s", vim.fn.line("."), vim.fn.col("."))
			end,
		},
		separator = "  ",
		icon = "",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.fg, colors.bg },
	},
}

gls.right[7] = {
	Percentage = {
		provider = {
			function()
				local p = math.floor((vim.fn.line(".") / vim.fn.line("$")) * 100)
				if vim.fn.line(".") == 1 then
					return "ﬢ"
				elseif vim.fn.line(".") == vim.fn.line("$") then
					return "ﬠ"
				else
					return string.format("(%s%%)", p)
				end
			end,
		},
		separator = " ",
		icon = "",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.grey, colors.bg },
	},
}

-- gls.right[6] = {
--  BufferType = {
--      provider = "FileTypeName",
--      condition = condition.hide_in_width,
--      separator = "  ",
--      separator_highlight = { colors.bg, colors.bg },
--      highlight = { colors.grey, colors.bg },
--  },
-- }

-- gls.right[8] = {
--  FileEncode = {
--      provider = "FileEncode",
--      condition = condition.hide_in_width,
--      separator = " ",
--      separator_highlight = { "NONE", colors.bg },
--      highlight = { colors.grey, colors.bg },
--  },
-- }

gls.right[9] = {
	Space = {
		provider = function()
			return " "
		end,
		separator = "",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.orange, colors.bg },
	},
}

-- =================================================================

gls.short_line_left[1] = {
	leftSemi = {
		provider = function()
			return ""
		end,
		highlight = { colors.lightbg, colors.bg },
	},
}

gls.short_line_left[2] = {
	FileIcon = {
		provider = "FileIcon",
		-- condition = condition.buffer_not_empty,
		condition = function()
			local tbl = { ["NvimTree"] = true, ["dashboard"] = true, [" "] = true }
			if tbl[vim.bo.filetype] then
				return false
			end
			return true
		end,
		highlight = {
			require("galaxyline.provider_fileinfo").get_file_icon_color,
			colors.lightbg,
		},
		separator = "",
	},
}

gls.short_line_left[3] = {
	NvimTreeIcon = {
		provider = function()
			return " "
		end,
		condition = function()
			local tbl = { ["NvimTree"] = true }
			if tbl[vim.bo.filetype] then
				return true
			end
			return false
		end,
		highlight = {
			require("galaxyline.provider_fileinfo").get_file_icon_color,
			colors.lightbg,
		},
	},
}

gls.short_line_left[4] = {
	FileNameShort = {
		provider = function()
			if vim.bo.filetype == "NvimTree" then
				return "File Explorer"
			end
			return vim.fn.expand("%:t")
		end,
		condition = function()
			local tbl = { ["dashboard"] = true, [" "] = true }
			if tbl[vim.bo.filetype] then
				return false
			end
			return condition.buffer_not_empty
		end,
		highlight = { colors.darkfg, colors.lightbg },
		separator = "",
	},
}

gls.short_line_left[5] = {
	rightSemi = {
		provider = function()
			return ""
		end,
		highlight = { colors.lightbg, colors.bg },
		separator = "",
		separator_highlight = { colors.bg, colors.bg },
	},
}
