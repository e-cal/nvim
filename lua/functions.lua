local api = vim.api

-- Trim whitespace
api.nvim_exec(
[[
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
]], false)

api.nvim_exec(
[[
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "="
endfunction
]], false)

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

PasteImg = function ()
	-- image
	create_dir('img')
	local name = get_name()
	local path = 'img/' .. name .. '.png'
	os.execute(string.format(paste_cmd, path))

	-- text
    local template = '<img src="%s" width=600px />'
	local pasted_txt = string.format(template, path)
    vim.cmd("normal a"..pasted_txt)
end

api.nvim_command("command! PasteImg :lua PasteImg()")

api.nvim_command("command! LspFormatting :lua vim.lsp.buf.formatting()")

