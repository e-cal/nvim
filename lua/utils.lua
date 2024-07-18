local api = vim.api

P = function(v)
	print(vim.inspect(v))
	return v
end

Utils = {}

Utils.make_command = function(name, nargs)
	local str
	if nargs ~= nil then
		str = string.format("command! -nargs=%s %s lua %s()", nargs, name, name)
	else
		str = string.format("command! %s lua %s()", name, name)
	end
	api.nvim_command(str)
end

-- Utils.make_command = function(name, args)
-- 	local str = string.format("command! %s lua %s()", name, name)
-- 	api.nvim_command(str)
-- end

Utils.make_augroups = function(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command("augroup " .. group_name)
		api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			api.nvim_command(command)
		end
		api.nvim_command("augroup END")
	end
end

Utils.get_hl = function(hl_group, attr)
	if attr == "fg" then
		attr = "foreground"
	elseif attr == "bg" then
		attr = "background"
	end

	local color = vim.api.nvim_get_hl_by_name(hl_group, true)[attr]
	color = string.format("#%06x", color)
	return color
end

Utils.merge = function(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

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
Utils.brightness_modifier = function(rgb_color, parcentage)
	local color = rgb_str2num(rgb_color)
	color.red = clamp(color.red + (color.red * parcentage / 100), 0, 255)
	color.green = clamp(color.green + (color.green * parcentage / 100), 0, 255)
	color.blue = clamp(color.blue + (color.blue * parcentage / 100), 0, 255)
	return rgb_num2str(color)
end

-- The function that replace those quirky html symbols.
local function split_lines(value)
	value = string.gsub(value, "&nbsp;", " ")
	value = string.gsub(value, "&gt;", ">")
	value = string.gsub(value, "&lt;", "<")
	value = string.gsub(value, "\\", "")
	-- value = string.gsub(value, "```python", "")
	-- value = string.gsub(value, "```", "")
	return vim.split(value, "\n", { plain = true, trimempty = true })
end

-- The function name is the same as what you found in the neovim repo.
-- I just remove those unused codes.
-- Actually, this function doesn't "convert input to markdown".
-- I just keep the function name the same for reference.
local function convert_input_to_markdown_lines(input, contents)
	contents = contents or {}
	assert(type(input) == "table", "Expected a table for LSP input")
	if input.kind then
		local value = input.value or ""
		vim.list_extend(contents, split_lines(value))
	end
	if (contents[1] == "" or contents[1] == nil) and #contents == 1 then
		return {}
	end
	return contents
end

-- The overwritten hover function that pyright uses.
-- Note that other language server can use the default one.
Utils.custom_hover = function(_, result, ctx, config)
	config = config or {}
	config.focus_id = ctx.method
	if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
		-- Ignore result since buffer changed. This happens for slow language servers.
		return
	end
	if not (result and result.contents) then
		if config.silent ~= true then
			vim.notify("No information available")
		end
		return
	end
	local contents ---@type string[]
	contents = convert_input_to_markdown_lines(result.contents)
	if vim.tbl_isempty(contents) then
		if config.silent ~= true then
			vim.notify("No information available")
		end
		return
	end
	-- Notice here. The "plaintext" string was originally "markdown".
	-- The reason of using "plaintext" instead of "markdown" is becasue
	-- of the bracket characters ([]). Markdown will hide single bracket,
	-- so when your docstrings consist of numpy or pytorch or python list,
	-- you will get garbadge hover results.
	-- The bad side of "plaintext" is that you never get syntax highlighting.
	-- I personally don't care about this.
	-- return require("vim.lsp.util").open_floating_preview(contents, "markdown", config)
	local float_buf, win = require("vim.lsp.util").open_floating_preview(contents, "markdown", config)
	vim.api.nvim_win_set_option(win, "conceallevel", 0)
	vim.api.nvim_win_set_option(win, "linebreak", true)
	return float_buf, win
end

Utils.keys = function(str)
	return function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
	end
end

return Utils
