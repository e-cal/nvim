local remote_dirs = {} -- { [local_dir] = remote_dest }
local persist_file = vim.fn.stdpath("data") .. "/remote_dirs.json"
local rsync_excludes = {
	"--exclude=data/",
	"--exclude=.venv/",
	"--exclude=.git/",
	"--exclude=__pycache__/",
}

local function load_remote_dirs()
	if vim.fn.filereadable(persist_file) == 1 then
		local content = table.concat(vim.fn.readfile(persist_file), "\n")
		local ok, data = pcall(vim.fn.json_decode, content)
		if ok and type(data) == "table" then
			remote_dirs = data
		else
			vim.notify("Failed to load remote_dirs from " .. persist_file, vim.log.levels.WARN)
		end
	end
end

local function save_remote_dirs()
	local ok, json = pcall(vim.fn.json_encode, remote_dirs)
	if ok then
		vim.fn.writefile({ json }, persist_file)
	else
		vim.notify("Failed to save remote_dirs to " .. persist_file, vim.log.levels.ERROR)
	end
end

local function add_remote_dir(local_dir, remote_dest)
	local abs_local_dir = vim.fn.expand(local_dir or vim.fn.getcwd())
	remote_dirs[abs_local_dir] = remote_dest
	save_remote_dirs()
	print("Added remote dir: " .. abs_local_dir .. " -> " .. remote_dest)
end

local function remove_remote_dir(local_dir)
	local abs_local_dir = vim.fn.expand(local_dir)
	if remote_dirs[abs_local_dir] then
		remote_dirs[abs_local_dir] = nil
		save_remote_dirs()
		print("Removed remote dir: " .. abs_local_dir)
	else
		vim.notify("No remote directory found for " .. abs_local_dir, vim.log.levels.WARN)
	end
end

local function list_remote_dirs()
	if next(remote_dirs) == nil then
		print("No remote directories configured.")
		return
	end
	for local_dir, remote_dest in pairs(remote_dirs) do
		print(local_dir .. " -> " .. remote_dest)
	end
end

local function sync_file(filepath)
	local abs_filepath = vim.fn.expand(filepath)
	if abs_filepath:match("data/") or abs_filepath:match(".venv/") or abs_filepath:match(".git/") then
		return
	end
	for local_dir, remote_dest in pairs(remote_dirs) do
		if abs_filepath:find(local_dir, 1, true) == 1 then
			local rel_path = abs_filepath:sub(#local_dir + 2)
			local source = abs_filepath
			local dest = remote_dest
			if not vim.fn.isdirectory(abs_filepath) then
				source = vim.fn.fnamemodify(abs_filepath, ":h")
				rel_path = vim.fn.fnamemodify(rel_path, ":h")
				if rel_path ~= "" then
					dest = remote_dest .. "/" .. rel_path
				end
			end

			-- Define rsync arguments
			local rsync_args = {
				"rsync",
				"-av",
				"--progress",
			}
			for _, exclude in ipairs(rsync_excludes) do
				table.insert(rsync_args, exclude)
			end

			-- Append source and dest
			table.insert(rsync_args, source)
			table.insert(rsync_args, dest)

			-- Run rsync directly
			vim.fn.jobstart(rsync_args, {
				on_stdout = function(_, data)
					if data then
						for _, line in ipairs(data) do
							if line ~= "" then
								print(line)
							end
						end
					end
				end,
				on_stderr = function(_, data)
					if data then
						vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
					end
				end,
				on_exit = function(_, code)
					if code == 0 then
						print("Synced " .. source .. " to " .. dest)
					else
						vim.notify("Sync failed for " .. source, vim.log.levels.ERROR)
					end
				end,
			})
			return
		end
	end
	vim.notify("No remote destination found for " .. abs_filepath, vim.log.levels.WARN)
end
-- Expose functions to the global namespace
_G.remote_sync = {
	add = add_remote_dir,
	remove = remove_remote_dir,
	list = list_remote_dirs,
	sync = sync_file,
}

-- Load remote_dirs on startup
load_remote_dirs()

-- Set up autocommands
vim.api.nvim_create_augroup("RemoteSync", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "RemoteSync",
	callback = function()
		local filepath = vim.fn.expand("%:p")
		if filepath:match("data/") or filepath:match(".venv/") or filepath:match(".git/") then
			return
		end
		sync_file(filepath)
	end,
})

-- Commands for convenience
vim.api.nvim_create_user_command("RemoteAdd", function(opts)
	local args = vim.split(opts.args, " ")
	if #args == 0 then
		vim.notify(
			"Usage: RemoteAdd [<local_dir>] <remote_dest>\n  - <local_dir>: Local directory (defaults to cwd if omitted)\n  - <remote_dest>: Format: user@server:/path",
			vim.log.levels.ERROR
		)
		return
	end
	-- If only one arg, it's the remote_dest; local_dir defaults to cwd
	local local_dir, remote_dest
	if #args == 1 then
		local_dir = nil
		remote_dest = args[1]
	else
		local_dir = args[1]
		remote_dest = args[2]
	end
	if not remote_dest:match("^[^@]+@[^:]+:.*$") then
		vim.notify(
			"Invalid <remote_dest> format: " .. remote_dest .. "\n  - Expected: user@server:path/to/project",
			vim.log.levels.ERROR
		)
		return
	end
	add_remote_dir(local_dir, remote_dest)
end, { nargs = "*" })

vim.api.nvim_create_user_command("RemoteRemove", function(opts)
	if opts.args == "" then
		vim.notify("Usage: RemoteRemove <local_dir>", vim.log.levels.ERROR)
		return
	end
	remove_remote_dir(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("RemoteList", list_remote_dirs, {})
vim.api.nvim_create_user_command("RemoteSync", function()
	sync_file(vim.fn.expand("%:p"))
end, {})

-- New command for full directory sync
vim.api.nvim_create_user_command("RemoteFullSync", function(opts)
	local local_dir = opts.args ~= "" and vim.fn.expand(opts.args) or vim.fn.getcwd()
	if not remote_dirs[local_dir] then
		vim.notify("No remote destination found for " .. local_dir, vim.log.levels.ERROR)
		return
	end
	local remote_dest = remote_dirs[local_dir]

	-- Define rsync arguments for full directory sync
	local rsync_args = {
		"rsync",
		"-av",
		"--progress",
	}
	for _, exclude in ipairs(rsync_excludes) do
		table.insert(rsync_args, exclude)
	end
	table.insert(rsync_args, local_dir .. "/") -- Trailing slash ensures directory contents are synced
	table.insert(rsync_args, remote_dest)

	-- Run rsync
	vim.fn.jobstart(rsync_args, {
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						print(line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
			end
		end,
		on_exit = function(_, code)
			if code == 0 then
				print("Full sync completed for " .. local_dir .. " to " .. remote_dest)
			else
				vim.notify("Full sync failed for " .. local_dir, vim.log.levels.ERROR)
			end
		end,
	})
end, { nargs = "?" })
