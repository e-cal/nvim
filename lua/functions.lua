local F = {}
local api = vim.api

-- Trim whitespace
api.nvim_exec(
[[
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
]],
false)

-- Paste images
local paste_cmd = 'xclip -selection clipboard -t image/png -o > %s'

local create_dir = function (dir)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, 'p')
	end
end

local get_name = function ()
	local index = 1
	for output in io.popen('ls img'):lines() do
		if output == 'image'..index..'.png' then
			index = index + 1
		else
			break
		end
	end
	return 'image'..index
end

F.paste_img = function ()
	-- image
	create_dir('img')
	local name = get_name()
	local path = 'img/' .. name .. '.png'
	os.execute(string.format(paste_cmd, path))

	-- text
	local pasted_txt = string.format('![](%s)', path)
    vim.cmd("normal a"..pasted_txt)
end

api.nvim_exec("command! PasteImg :lua require'functions'.paste_img()", false)

return F
