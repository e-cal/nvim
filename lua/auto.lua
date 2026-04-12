local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
--                                   Global                                   --
--------------------------------------------------------------------------------
augroup("global", { clear = true })
autocmd({ "VimLeave" }, { group = "global", command = "StoreSession" })
autocmd({ "BufEnter" }, { group = "global", command = "LspStart" })
-- autocmd({ "VimEnter" }, {
-- 	group = "global",
-- 	callback = function()
-- 		local oc = require("opencode")
-- 		require("opencode.cli.server")
-- 			.get(false)
-- 			:next(function(server)
-- 				vim.notify(
-- 					"Connected to opencode on port " .. server.port,
-- 					vim.log.levels.INFO,
-- 					{ title = "opencode" }
-- 				)
-- 			end)
-- 			:catch(function(err)
-- 				vim.notify("Starting opencode...", vim.log.levels.INFO, { title = "opencode" })
-- 				oc.start()
-- 			end)
-- 	end,
-- })
autocmd({ "CursorMoved" }, {
	group = "global",
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})

autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
	group = "global",
	callback = function()
		local excluded_filetypes = { markdown = true, json = true }
		if not excluded_filetypes[vim.bo.filetype] then
			vim.bo.formatoptions = "jql"
		end
	end,
})

--------------------------------------------------------------------------------
--                                 CWD Watch                                   --
--------------------------------------------------------------------------------
local cwd_watch = {
	group = augroup("cwd_watch", { clear = true }),
	debounce_timer = nil,
	paths = {},
	recent_writes = {},
	root = nil,
	watcher = nil,
}

local RECENT_WRITE_TTL_MS = 1000

local function normalize_path(path)
	if path == nil or path == "" then
		return nil
	end
	if vim.fs and vim.fs.normalize then
		return vim.fs.normalize(path)
	end
	return vim.fn.fnamemodify(path, ":p")
end

local function canonical_path(path)
	local normalized = normalize_path(path)
	if not normalized then
		return nil
	end
	local real = vim.uv.fs_realpath(normalized)
	return real or normalized
end

local function path_in_root(path, root)
	if not path or not root then
		return false
	end
	if path == root then
		return true
	end
	return path:sub(1, #root + 1) == root .. "/"
end

local function stop_timer()
	if cwd_watch.debounce_timer then
		cwd_watch.debounce_timer:stop()
		cwd_watch.debounce_timer:close()
		cwd_watch.debounce_timer = nil
	end
end

local function stop_watcher()
	stop_timer()
	if cwd_watch.watcher then
		cwd_watch.watcher:stop()
		cwd_watch.watcher:close()
		cwd_watch.watcher = nil
	end
	cwd_watch.paths = {}
	cwd_watch.recent_writes = {}
	cwd_watch.root = nil
end

local function mark_recent_write(path)
	if not path or path == "" then
		return
	end
	local full_path = canonical_path(path)
	if not full_path then
		return
	end

	local now = vim.uv.now()
	cwd_watch.recent_writes[full_path] = now

	for tracked_path, ts in pairs(cwd_watch.recent_writes) do
		if now - ts > RECENT_WRITE_TTL_MS then
			cwd_watch.recent_writes[tracked_path] = nil
		end
	end
end

local function was_recently_written(path)
	local ts = cwd_watch.recent_writes[path]
	if not ts then
		return false
	end

	if vim.uv.now() - ts > RECENT_WRITE_TTL_MS then
		cwd_watch.recent_writes[path] = nil
		return false
	end

	return true
end

local function display_path(path)
	local display = vim.fn.fnamemodify(path, ":~:.")
	return display:gsub("^%./", "")
end

local function reload_buffers(changed_paths)
	local root = cwd_watch.root
	if not root then
		return
	end

	local reload_all = changed_paths == nil or vim.tbl_isempty(changed_paths)
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
			local name = canonical_path(vim.api.nvim_buf_get_name(bufnr))
			if name and path_in_root(name, root) then
				if not was_recently_written(name) and (reload_all or changed_paths[name]) then
					if vim.fn.filereadable(name) == 1 and not vim.bo[bufnr].modified then
						vim.notify("Reloading " .. display_path(name), vim.log.levels.INFO, { title = "nvim" })
						vim.cmd("silent! checktime " .. bufnr)
					end
				end
			end
		end
	end
end

local function schedule_reload(changed_path)
	if changed_path and changed_path ~= "" and cwd_watch.root then
		local full_path = canonical_path(cwd_watch.root .. "/" .. changed_path)
		if full_path then
			cwd_watch.paths[full_path] = true
		end
	end

	stop_timer()
	cwd_watch.debounce_timer = vim.uv.new_timer()
	cwd_watch.debounce_timer:start(
		150,
		0,
		vim.schedule_wrap(function()
			local changed_paths = next(cwd_watch.paths) and vim.deepcopy(cwd_watch.paths) or nil
			cwd_watch.paths = {}
			reload_buffers(changed_paths)
			stop_timer()
		end)
	)
end

local function start_watcher(root)
	root = canonical_path(root)
	if not root or root == cwd_watch.root then
		return
	end

	stop_watcher()

	local watcher = vim.uv.new_fs_event()
	local ok, err = pcall(function()
		watcher:start(
			root,
			{ recursive = true },
			vim.schedule_wrap(function(watch_err, changed_path)
				if watch_err then
					vim.notify("cwd-watch: " .. tostring(watch_err), vim.log.levels.WARN, { title = "nvim" })
					return
				end
				schedule_reload(changed_path)
			end)
		)
	end)
	if not ok then
		watcher:close()
		vim.notify("cwd-watch: failed to watch " .. root .. ": " .. tostring(err), vim.log.levels.ERROR, {
			title = "nvim",
		})
		return
	end

	cwd_watch.root = root
	cwd_watch.watcher = watcher
	vim.o.autoread = true
end

autocmd({ "VimEnter", "DirChanged" }, {
	group = cwd_watch.group,
	callback = function()
		start_watcher(vim.fn.getcwd())
	end,
})

autocmd({ "BufWritePre", "BufWritePost" }, {
	group = cwd_watch.group,
	callback = function(args)
		mark_recent_write(args.file)
	end,
})

autocmd("VimLeavePre", {
	group = cwd_watch.group,
	callback = function()
		stop_watcher()
	end,
})

--------------------------------------------------------------------------------
--                                 Filetypes                                  --
--------------------------------------------------------------------------------
augroup("markdown", { clear = true })
autocmd({ "BufEnter" }, {
	group = "markdown",
	pattern = "*.md",
	callback = function()
		vim.cmd('syntax match markdownIgnore "\\v\\w_\\w"')
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.cmd("set spell")
		-- Enable wrapping and linebreak
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		-- Disable auto newline at textwidth
		vim.opt_local.formatoptions:remove("t")
		vim.opt_local.textwidth = 0
		-- Map movement keys to their screen-line equivalents
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		vim.keymap.set("n", "^", "g^", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		-- Same for visual mode
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
		vim.keymap.set("v", "^", "g^", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
	end,
})

augroup("json", { clear = true })
autocmd({ "BufEnter" }, {
	group = "json",
	pattern = "*.json*",
	callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
    end,
})

augroup("python", { clear = true })
autocmd({ "BufEnter" }, {
	group = "python",
	pattern = "*.py",
	callback = function()
		vim.cmd("setlocal indentkeys-=<:> indentkeys-=:")
	end,
})

augroup("conf", { clear = true })
autocmd({ "BufEnter" }, {
	group = "conf",
	pattern = "*.conf",
	command = "setlocal ft=conf",
})
autocmd({ "BufEnter" }, {
	group = "conf",
	pattern = "*.yuck",
	command = "setlocal ts=2 sw=2 sts=2",
})

augroup("c", { clear = true })
autocmd({ "BufEnter" }, {
	group = "c",
	pattern = "Makefile",
	command = "setlocal noexpandtab",
})

augroup("web", { clear = true })
autocmd({ "BufEnter" }, {
	group = "web",
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.html", "*.css", "*.scss", "*.json" },
	command = "setlocal ts=2 sw=2 sts=2",
})

augroup("nix", { clear = true })
autocmd({ "BufEnter" }, {
	group = "nix",
	pattern = { "*.nix" },
	command = "setlocal ts=2 sw=2 sts=2",
})


augroup("latex", { clear = true })
autocmd({ "BufEnter" }, {
	group = "latex",
	pattern = "*.tex",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
		-- Map movement keys to their screen-line equivalents
		vim.keymap.set("n", "j", "gj", { buffer = true })
		vim.keymap.set("n", "k", "gk", { buffer = true })
		vim.keymap.set("n", "0", "g0", { buffer = true })
		vim.keymap.set("n", "^", "g^", { buffer = true })
		vim.keymap.set("n", "$", "g$", { buffer = true })
		-- Same for visual mode
		vim.keymap.set("v", "j", "gj", { buffer = true })
		vim.keymap.set("v", "k", "gk", { buffer = true })
		vim.keymap.set("v", "0", "g0", { buffer = true })
		vim.keymap.set("v", "^", "g^", { buffer = true })
		vim.keymap.set("v", "$", "g$", { buffer = true })
	end,
})
