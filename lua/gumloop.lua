local M = {}

local base = vim.fs.normalize(vim.fn.expand("~/gumloop"))
M.backend = base .. "/backend/backend"
M.frontend = base .. "/frontend"

function M.contains(path, root)
	path = vim.fs.normalize(path)
	return path == root or path:sub(1, #root + 1) == root .. "/"
end

function M.buffer_in(bufnr, root)
	return M.contains(vim.api.nvim_buf_get_name(bufnr), root)
end

-- Use Python's YAML parser and regex engine, matching pre-commit's config semantics.
local backend_format_policy = [[
import pathlib
import re
import sys
import yaml

root = pathlib.Path(sys.argv[1])
filename = pathlib.Path(sys.argv[2]).relative_to(root).as_posix()
config = yaml.safe_load((root / '.pre-commit-config.yaml').read_text())
hooks = [hook for repo in config['repos'] for hook in repo['hooks']
         if hook['id'] == 'ruff-format']
if len(hooks) != 1:
    raise ValueError('Expected exactly one ruff-format hook')
hook = hooks[0]
allowed = all(
    re.search(scope.get('files', ''), filename)
    and not re.search(scope.get('exclude', '^$'), filename)
    for scope in (config, hook)
)
print('allowed' if allowed else 'confirm')
]]

function M.format(opts, callback)
	opts = vim.tbl_extend("force", {}, opts or {})
	local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	if bufnr == 0 then
		bufnr = vim.api.nvim_get_current_buf()
	end
	if vim.bo[bufnr].filetype == "python" and M.buffer_in(bufnr, M.backend) then
		local ok, result = pcall(function()
			return vim.system({
				M.backend .. "/.venv/bin/python",
				"-c",
				backend_format_policy,
				vim.fs.dirname(M.backend),
				vim.api.nvim_buf_get_name(bufnr),
			}, { text = true }):wait(3000)
		end)
		if not ok or result.code ~= 0 then
			vim.notify(
				"Gumloop: cannot read formatting policy; formatting cancelled.\n"
					.. (ok and (result.stderr or "Policy check failed") or tostring(result)),
				vim.log.levels.ERROR
			)
			return
		end
		if vim.trim(result.stdout) ~= "allowed" then
			local choice = vim.fn.confirm(
				"Gumloop: "
					.. vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
					.. " is not whitelisted for Ruff formatting in .pre-commit-config.yaml.\nFormat anyway?",
				"&No\n&Yes",
				1
			)
			if choice ~= 2 then
				return
			end
		end
		-- Never substitute an LSP/global formatter if the repository's tool is unavailable.
		opts.lsp_fallback = nil
		opts.lsp_format = "never"
		opts.formatters = { "gumloop_ruff" }
	end
	opts.bufnr = bufnr
	return require("conform").format(opts, callback)
end

function M.conform(opts)
	local frontend_types = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"html",
		"css",
		"scss",
		"less",
		"markdown",
		"markdown.mdx",
		"json",
		"jsonc",
		"yaml",
	}
	for _, ft in ipairs(frontend_types) do
		local default = opts.formatters_by_ft[ft]
		opts.formatters_by_ft[ft] = function(bufnr)
			if M.buffer_in(bufnr, M.frontend) then
				return { "gumloop_prettier" }
			end
			return default or {}
		end
	end
	local python_default = opts.formatters_by_ft.python
	opts.formatters_by_ft.python = function(bufnr)
		return M.buffer_in(bufnr, M.backend) and { "gumloop_ruff" } or python_default
	end
	opts.formatters.gumloop_ruff = {
		inherit = "ruff_format",
		command = M.backend .. "/.venv/bin/ruff",
		cwd = function()
			return M.backend
		end,
	}
	opts.formatters.gumloop_prettier = {
		inherit = "prettier",
		command = M.frontend .. "/node_modules/.bin/prettier",
		cwd = function()
			return M.frontend
		end,
	}
	return opts
end

local function setup_flake8()
	local ns = vim.api.nvim_create_namespace("gumloop_flake8")
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		group = vim.api.nvim_create_augroup("GumloopLint", { clear = true }),
		pattern = "*.py",
		callback = function(event)
			local bufnr = event.buf
			if not M.buffer_in(bufnr, M.backend) then
				return
			end
			local command = M.backend .. "/.venv/bin/flake8"
			if vim.fn.executable(command) ~= 1 then
				return
			end
			local tick = vim.api.nvim_buf_get_changedtick(bufnr)
			local filename = vim.api.nvim_buf_get_name(bufnr)
			local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
			vim.system(
				{
					command,
					"--select=E9,F7,F82",
					"--format=%(row)d:%(col)d:%(code)s:%(text)s",
					"--stdin-display-name",
					filename,
					"-",
				},
				{ cwd = M.backend, stdin = text, text = true },
				vim.schedule_wrap(function(result)
					if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_buf_get_changedtick(bufnr) ~= tick then
						return
					end
					if result.code > 1 then
						vim.notify("Gumloop Flake8: " .. (result.stderr or "check failed"), vim.log.levels.WARN)
						return
					end
					local diagnostics = {}
					for line in (result.stdout or ""):gmatch("[^\n]+") do
						local row, col, code, message = line:match("^(%d+):(%d+):([^:]+):(.*)$")
						if row then
							diagnostics[#diagnostics + 1] = {
								lnum = tonumber(row) - 1,
								col = tonumber(col) - 1,
								code = code,
								message = message,
								source = "flake8 (CI)",
								severity = vim.diagnostic.severity.ERROR,
							}
						end
					end
					vim.diagnostic.set(ns, bufnr, diagnostics)
				end)
			)
		end,
	})
end

function M.setup_lsp()
	local ruff = vim.lsp.config.ruff
	local original_cmd, original_init = ruff.cmd, ruff.before_init
	vim.lsp.config("ruff", {
		cmd = function(dispatchers, config)
			if config.root_dir and M.contains(config.root_dir, M.backend) then
				return vim.lsp.rpc.start({ M.backend .. "/.venv/bin/ruff", "server" }, dispatchers, { cwd = M.backend })
			end
			if type(original_cmd) == "function" then
				return original_cmd(dispatchers, config)
			end
			return vim.lsp.rpc.start(original_cmd, dispatchers)
		end,
		before_init = function(params, config)
			if original_init then
				original_init(params, config)
			end
			if config.root_dir and M.contains(config.root_dir, M.backend) then
				-- Replace editor overrides only for this client, not the shared default config.
				config.init_options = { settings = { configurationPreference = "filesystemFirst" } }
				params.initializationOptions = config.init_options
			end
		end,
	})

	for _, name in ipairs({ "ts_ls", "biome" }) do
		local original = vim.lsp.config[name]
		local root_dir, markers = original.root_dir, original.root_markers
		vim.lsp.config(name, {
			root_dir = function(bufnr, on_dir)
				if M.buffer_in(bufnr, M.frontend) then
					return
				end
				if type(root_dir) == "function" then
					return root_dir(bufnr, on_dir)
				end
				on_dir(root_dir or (markers and vim.fs.root(bufnr, markers)) or vim.fn.getcwd())
			end,
		})
	end

	for name, args in pairs({ oxlint = { "--lsp" }, tsc = { "--lsp", "--stdio" } }) do
		vim.lsp.config(name, {
			cmd = vim.list_extend({ M.frontend .. "/node_modules/.bin/" .. name }, args),
			cmd_cwd = M.frontend,
			root_dir = function(bufnr, on_dir)
				if M.buffer_in(bufnr, M.frontend) then
					on_dir(M.frontend)
				end
			end,
		})
		vim.lsp.enable(name)
	end
	setup_flake8()
end

return M
