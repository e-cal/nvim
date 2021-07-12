local api = vim.api

-- Trim whitespace
api.nvim_exec([[
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
]], false)

-- Folds in markdown
api.nvim_exec([[
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
local paste_cmd = Markdown.imagePasteCommand

local create_dir = function(dir)
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
end

local get_name = function()
    local index = 1
    for _ in io.popen('ls img'):lines() do index = index + 1 end
    return 'image' .. index
end

PasteImg = function()
    create_dir(Markdown.imageDir)
    local name = get_name()
    local path = string.format(Markdown.imageDir .. '/%s.png', name)
    os.execute(string.format(paste_cmd, path))

    local template
    local size = Markdown.imageDefaultWidth
    if Markdown.imagePasteSyntax == 'html' then
        if size ~= nil then
            template = '<img src="%s" width=' .. size .. 'px />'
        else
            template = '<img src="%s" />'
        end
    elseif Markdown.imagePasteSyntax == 'obsidian' then
        if size ~= nil then
            template = '![[%s|' .. size .. ']]'
        else
            template = '![[%s]]'
        end
    else
        template = Markdown.imagePasteSyntax
    end
    local pasted_txt = string.format(template, path)
    vim.cmd("normal a" .. pasted_txt)
end

Utils.make_command("PasteImg") -- need to be str
api.nvim_command("command! PasteImg :lua PasteImg()")

api.nvim_command("command! LspFormatting :lua vim.lsp.buf.formatting()")

