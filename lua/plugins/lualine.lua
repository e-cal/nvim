return {
	"nvim-lualine/lualine.nvim",
	name = "lualine",
	config = function()
		local lualine = require("lualine")

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

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 100
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
				component_separators = "",
				section_separators = "",
				theme = {
					normal = { c = { fg = colors.fg, bg = colors.bg } },
					inactive = { c = { fg = colors.fg, bg = colors.bg } },
				},
			},
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
			extensions = { "quickfix", "neo-tree", "lazy", "aerial", "trouble" },
		}

		local function ins_left(component, inactive)
			table.insert(config.sections.lualine_c, component)
			if inactive then
				table.insert(config.inactive_sections.lualine_c, component)
			end
		end
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end
		local function ins_inactive(component)
			table.insert(config.inactive_sections.lualine_c, component)
		end

		-- mode indicator
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

		-- center inactive buffer line
		-- ins_inactive({
		-- 	function()
		-- 		return "%="
		-- 	end,
		-- })

		-- file info
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
			local full_path = vim.fn.expand("%:p")
			local cwd = vim.fn.getcwd()
			local relative_path = full_path:gsub("^" .. vim.pesc(cwd) .. "/", "")
			return relative_path
		end
		ins_left({
			get_filename,
			cond = conditions.buffer_not_empty,
			color = function()
				local bufnr = vim.fn.bufnr("%")
				local fg = colors.fg -- not modified
				if vim.fn.getbufvar(bufnr, "&modified") == 1 then
					fg = colors.command -- unsaved
				elseif not vim.bo.modifiable then
					fg = colors.replace -- readonly
				end
				return { fg = fg, bg = colors.bg_bright }
			end,
			padding = { left = 0, right = 0 },
		})
		ins_inactive({
			get_filename,
			cond = conditions.buffer_not_empty,
			color = function()
				local bufnr = vim.fn.bufnr("%")
				local fg = colors.fg_dark -- not modified
				if vim.fn.getbufvar(bufnr, "&modified") == 1 then
					fg = colors.command -- unsaved
				elseif not vim.bo.modifiable then
					fg = colors.replace -- readonly
				end
				return { fg = fg, bg = colors.bg_bright }
			end,
			padding = { left = 0, right = 0 },
		})
		ins_left({
			function()
				return "█"
			end,
			color = { fg = colors.bg_bright, bg = colors.bg },
			padding = { left = 0, right = 0 },
		}, true)

		-- git
		ins_left({
			"branch",
			icon = {
				"",
			},
			color = { fg = colors.fg_dark },
			cond = conditions.hide_in_width,
		})
		ins_left({
			"diff",
			cond = conditions.hide_in_width,
		})

		-- Middle section
		-- ins_left({
		-- 	function()
		-- 		return "%="
		-- 	end,
		-- })

		ins_right({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			cond = conditions.hide_in_width,
		})

		-- lsp servers
		ins_right({
			function()
				local prt_status_info = require("parrot.config").get_status_info()
				local model = prt_status_info.model:gsub(".*/", "")
				while model:match("%-[0-9]+$") do
				  model = model:gsub("%-[0-9]+$", "")
				end

				local clients = vim.lsp.get_active_clients()
				if next(clients) == nil then
					return model
				end

				local msg = ""
				local rename = { jedi_language_server = "jedi", ruff_lsp = "ruff" }
				for _, client in ipairs(clients) do
					if msg == "" then
						msg = rename[client.name] or client.name
					else
						msg = msg .. " + " .. (rename[client.name] or client.name)
					end
				end

				return msg .. " 󰚩 " .. model
			end,
			icon = "󱁤",
			color = { fg = colors.fg_dark },
			cond = conditions.hide_in_width,
		})

		-- venv
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
			color = { fg = colors.normal, bg = colors.bg_bright },
			padding = { left = 0, right = 0 },
		})

		-- cursor position
		ins_right({
			function()
				local line = vim.fn.line(".")
				local col = vim.fn.virtcol(".")
				return string.format("%d:%-2d", line, col)
			end,
			icon = { "󰉶 ", color = { fg = colors.bg_bright, bg = colors.normal } },
			color = { fg = colors.normal, bg = colors.bg_bright },
			padding = { left = 0, right = 1 },
		})

		-- scroll percentage
		ins_right({
			function()
				local current_line = vim.fn.line(".")
				local total_lines = vim.fn.line("$")
				local percent = math.floor((current_line / total_lines) * 100)
				local icons = { "▇", "▆", "▅", "▄", "▃", "▂", "▁", " " } -- █
				local index = math.max(math.ceil(percent / 13), 1)
				return icons[index]
			end,
			color = { fg = colors.bg_bright, bg = colors.normal },
			padding = { left = 0, right = 0 },
		})

		lualine.setup(config)
	end,
}
