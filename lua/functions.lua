local api = vim.api


vim.cmd('cabbrev f Format')

-- Trim whitespace
TrimWhitespace = function()
	local patterns = {
		[[%s/\s\+$//e]],
		[[%s/\($\n\s*\)\+\%$//]],
		[[%s/\%^\n\+//]],
		[[%s/\(\n\n\)\n\+/\1/]],
	}
	local save = vim.fn.winsaveview()
	for _, v in pairs(patterns) do
		api.nvim_exec(string.format("keepjumps keeppatterns silent! %s", v), false)
	end
	vim.fn.winrestview(save)
end
Utils.make_command("TrimWhitespace")

-- Paste images
local paste_cmd = "wl-paste -t image/png > %s"

local create_dir = function(dir)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

local get_name = function(start)
	local index = start
	for f in io.popen("ls img"):lines() do
		if string.find(f, "image%d%d%d%d.png") then
			index = index + 1
		end
	end
	local prefix = ""
	if index < 10 then
		prefix = "000"
	elseif index < 100 then
		prefix = "00"
	elseif index < 1000 then
		prefix = "0"
	end
	return "image" .. prefix .. index
end

PasteImg = function()
	create_dir("img")
	local name = get_name(1)
	local path = string.format("img/%s.png", name)
	os.execute(string.format(paste_cmd, path))

	local template
	local size = 600
	if size ~= nil then
		template = '<img src="%s" width=' .. size .. "px />"
	else
		template = '<img src="%s" />'
	end
	local pasted_txt = string.format(template, path)
	vim.cmd("normal a" .. pasted_txt)
end
Utils.make_command("PasteImg")

DelLastImg = function()
	local name = get_name(0)
	local path = string.format("img/%s.png", name)
	os.execute(string.format("rm %s", path))
end
Utils.make_command("DelLastImg")

CleanText = function()
	api.nvim_command("%s/–\\|•\\|▪/-/ge")
	api.nvim_command("%s/■/-/ge")
	api.nvim_command("%s/❑/↳ /ge")
	api.nvim_command("%s/’\\|‘/'/ge")
	api.nvim_command('%s/“\\|”/"/ge')
end
Utils.make_command("CleanText")

PS = function()
	api.nvim_command("PackerSync")
end
Utils.make_command("PS")

NewFile = function()
	local name = vim.fn.input("File name: ", "", "file")
	api.nvim_command("e " .. name)
end
Utils.make_command("NewFile")

TelescopeSearchDotfiles = function()
	require("telescope.builtin").find_files({ prompt_title = " Config ", cwd = "$DOTFILES/.config" })
end
Utils.make_command("TelescopeSearchDotfiles")

TelescopeSearchChats = function()
	require("telescope.builtin").grep_string({
		prompt_title = " Chats ",
		cwd = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
		search = "# topic",
	})
	-- require("telescope.builtin").find_files({
	-- 	prompt_title = " Chats ",
	-- 	cwd = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
	-- })
end
Utils.make_command("TelescopeSearchChats")

TelescopeSearchDir = function()
	local dir = vim.fn.input("Search from: ", "~/")
	if dir ~= "" and dir ~= nil then
		require("telescope.builtin").find_files({ prompt_title = string.format(" Searching %s ", dir), cwd = dir })
	else
		require("telescope.builtin").find_files()
	end
end
Utils.make_command("TelescopeSearchDir")

PreviewDoc = function()
	local filetype = vim.bo.filetype
	if filetype == "markdown" then
		api.nvim_command("MarkdownPreviewToggle")
	elseif filetype == "tex" then
		api.nvim_command("VimtexCompile")
	end
end
Utils.make_command("PreviewDoc")

OpenLast = function()
	vim.cmd("e " .. vim.v.oldfiles[1])
end
Utils.make_command("OpenLast")

local session_dir = vim.fn.stdpath("data") .. "/sessions/"

StoreSession = function()
	local dir = string.gsub(vim.fn.getcwd(), "/", "_")
	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end
	vim.cmd("mksession! " .. session_dir .. dir)
end
Utils.make_command("StoreSession")

RestoreSession = function()
	local dir = string.gsub(vim.fn.getcwd(), "/", "_")
	if vim.fn.isdirectory(session_dir) == 0 then
		vim.fn.mkdir(session_dir, "p")
	end
	local fp = session_dir .. dir
	local f = io.open(fp, "r")
	if f ~= nil then
		vim.cmd("source " .. fp)
	end
end
Utils.make_command("RestoreSession")

QuickfixToggle = function()
	for _, info in ipairs(vim.fn.getwininfo()) do
		if info.quickfix == 1 then
			vim.cmd("cclose")
		else
			vim.cmd("copen")
		end
	end
end
Utils.make_command("QuickfixToggle")

BufDeleteAll = function()
    vim.cmd[[w | let pos = getpos('.') | silent %bd | e# | bd# | call setpos('.', pos)]]
end
Utils.make_command("BufDeleteAll")
vim.cmd('cabbrev bda BufDeleteAll')

-- Reload a specific plugin config: :Reload opencode or :Reload (current file)
Reload = function(name)
	local config_dir = vim.fn.stdpath("config") .. "/lua"

	-- If no name given, try to infer from current buffer
	if not name or name == "" then
		local bufname = vim.fn.expand("%:t:r")
		local bufpath = vim.fn.expand("%:p")
		if bufpath:match("/plugins/") then
			name = bufname
		else
			vim.notify("Usage: :Reload <plugin_name> or run from a plugin file", vim.log.levels.WARN)
			return
		end
	end

	local plugin_file = config_dir .. "/plugins/" .. name .. ".lua"
	if vim.fn.filereadable(plugin_file) == 0 then
		vim.notify("Plugin file not found: " .. plugin_file, vim.log.levels.ERROR)
		return
	end

	-- Clear the module from cache
	package.loaded["plugins." .. name] = nil

	-- Reload and run config
	local ok, spec = pcall(dofile, plugin_file)
	if ok and spec and spec.config and type(spec.config) == "function" then
		local config_ok, err = pcall(spec.config)
		if config_ok then
			vim.notify("Reloaded: " .. name, vim.log.levels.INFO)
		else
			vim.notify("Error in config: " .. tostring(err), vim.log.levels.ERROR)
		end
	elseif not ok then
		vim.notify("Error loading file: " .. tostring(spec), vim.log.levels.ERROR)
	else
		vim.notify("Reloaded: " .. name .. " (no config function)", vim.log.levels.INFO)
	end
end
vim.api.nvim_create_user_command("Reload", function(opts)
	Reload(opts.args)
end, {
	nargs = "?",
	complete = function()
		local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
		local files = vim.fn.glob(plugins_dir .. "/*.lua", false, true)
		local names = {}
		for _, f in ipairs(files) do
			table.insert(names, vim.fn.fnamemodify(f, ":t:r"))
		end
		return names
	end,
})
