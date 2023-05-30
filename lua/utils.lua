local api = vim.api

P = function(v)
	print(vim.inspect(v))
	return v
end

Utils = {}

Utils.make_command = function(name, args)
	-- TODO: make this accept args so I can do `History n` and get the n recent files
	local str = string.format("command! %s lua %s()", name, name)
	api.nvim_command(str)
end

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
