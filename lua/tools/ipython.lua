local M = {}
local curl = require("plenary.curl")

M.config = {
	url = "http://localhost:5000/execute",
}

-- Icons for different scope types (customize these!)
M.icons = {
	buffer = "",
	class = "",
	["function"] = "󰊕",
	variable = "󰫧",
	block = "󰘦",
}

function M.setup(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
end

function M.send_to_repl(code, callback, line_range)
	if type(code) == "table" and #code > 0 then
		-- Normalize indentation by detecting the first line's indentation
		-- and removing that amount from all lines
		local min_indent = nil
		for _, line in ipairs(code) do
			if line:match("%S") then -- Only consider non-empty lines
				local indent = line:match("^%s*")
				local indent_len = #indent
				if min_indent == nil or indent_len < min_indent then
					min_indent = indent_len
				end
			end
		end

		-- Remove the minimum indentation from all lines
		if min_indent and min_indent > 0 then
			for i, line in ipairs(code) do
				if line:match("%S") then -- Only modify non-empty lines
					code[i] = line:sub(min_indent + 1)
				end
			end
		end

		-- Get current buffer's file path relative to cwd
		local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
		local start_line, end_line

		-- Use provided line range if available, otherwise detect from cursor/visual mode
		if line_range then
			start_line = line_range.start_line
			end_line = line_range.end_line
		elseif vim.fn.mode() == "v" or vim.fn.mode() == "V" then
			local _, srow = unpack(vim.fn.getpos("v"))
			local _, erow = unpack(vim.fn.getpos("."))
			start_line = math.min(srow, erow)
			end_line = math.max(srow, erow)
		else
			-- For current line or other operations
			start_line = vim.fn.line(".")
			end_line = start_line
		end

		local info_string = filepath .. " [" .. start_line .. "-" .. end_line .. "]"

		-- Check if the first line starts with # %%
		if code[1]:match("^# %%") then
			-- Append file path and line range to the existing comment
			code[1] = code[1] .. " " .. info_string
		else
			-- Prepend a new comment line with the file path and line range
			table.insert(code, 1, "# %% " .. info_string)
		end
	end

	-- Send request asynchronously with error handling
	local ok, result = pcall(curl.post, M.config.url, {
		body = vim.fn.json_encode({ code = code }),
		headers = {
			content_type = "application/json",
		},
		callback = vim.schedule_wrap(function(response)
			if response.status == 200 then
				local success, decoded = pcall(vim.fn.json_decode, response.body)
				if success then
					if callback then
						callback(true, decoded)
					end
				else
					vim.notify("Failed to decode IPython response", vim.log.levels.ERROR)
					if callback then
						callback(false, nil)
					end
				end
			else
				vim.notify("IPython request failed: " .. response.status, vim.log.levels.ERROR)
				if callback then
					callback(false, nil)
				end
			end
		end),
		on_error = vim.schedule_wrap(function(err)
			local error_msg = "IPython server error"
			if err.exit and err.exit == 7 then
				error_msg = "Could not connect to IPython server at " .. M.config.url
			elseif err.stderr and #err.stderr > 0 then
				error_msg = "IPython server error: " .. table.concat(err.stderr, " ")
			end
			vim.notify(error_msg, vim.log.levels.ERROR)
			if callback then
				callback(false, nil)
			end
		end),
	})

	if not ok then
		vim.schedule(function()
			vim.notify("Failed to send request to IPython server: " .. tostring(result), vim.log.levels.ERROR)
			if callback then
				callback(false, nil)
			end
		end)
	end
end

function M.get_visual_selection()
	local _, srow, scol = unpack(vim.fn.getpos("v"))
	local _, erow, ecol = unpack(vim.fn.getpos("."))

	if vim.fn.mode() == "V" then
		if srow > erow then
			return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
		else
			return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
		end
	end

	if vim.fn.mode() == "v" then
		if srow < erow or (srow == erow and scol <= ecol) then
			return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
		else
			return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
		end
	end
end

function M.run_selected_lines()
	local code = M.get_visual_selection()
	M.send_to_repl(code)
end

function M.run_current_line()
	local line = vim.api.nvim_buf_get_lines(0, vim.fn.line(".") - 1, vim.fn.line("."), true)
	M.send_to_repl(line)
end

-- Get all treesitter scopes in the current buffer
function M.get_scopes()
	local bufnr = vim.api.nvim_get_current_buf()
	local parser = vim.treesitter.get_parser(bufnr, "python")
	if not parser then
		vim.notify("Treesitter parser not available for Python", vim.log.levels.ERROR)
		return {}
	end

	local tree = parser:parse()[1]
	local root = tree:root()
	local scopes = {}

	-- Add whole buffer option
	local total_lines = vim.api.nvim_buf_line_count(bufnr)
	table.insert(scopes, {
		type = "buffer",
		name = "Whole Buffer",
		start_row = 0,
		end_row = total_lines - 1,
		start_col = 0,
		end_col = 0,
	})

	-- Query for various scope types
	local query_string = [[
		(class_definition
			name: (identifier) @class.name) @class.def

		(function_definition
			name: (identifier) @func.name) @func.def

		(assignment
			left: (identifier) @var.name) @var.def

		(if_statement
			condition: (comparison_operator
				(identifier) @if.name
				(string) @if.value)) @if.def
	]]

	local query = vim.treesitter.query.parse("python", query_string)

	for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
		local capture_name = query.captures[id]

		if capture_name == "class.def" then
			local name_node = node:field("name")[1]
			local name = vim.treesitter.get_node_text(name_node, bufnr)
			local start_row, start_col, end_row, end_col = node:range()

			table.insert(scopes, {
				type = "class",
				name = "class " .. name,
				start_row = start_row,
				end_row = end_row,
				start_col = start_col,
				end_col = end_col,
			})
		elseif capture_name == "func.def" then
			local name_node = node:field("name")[1]
			local name = vim.treesitter.get_node_text(name_node, bufnr)
			local start_row, start_col, end_row, end_col = node:range()

			table.insert(scopes, {
				type = "function",
				name = "def " .. name,
				start_row = start_row,
				end_row = end_row,
				start_col = start_col,
				end_col = end_col,
			})
		elseif capture_name == "var.def" then
			local name_node = node:field("left")[1]
			if name_node and name_node:type() == "identifier" then
				local name = vim.treesitter.get_node_text(name_node, bufnr)
				local start_row, start_col, end_row, end_col = node:range()

				table.insert(scopes, {
					type = "variable",
					name = name .. " = ...",
					start_row = start_row,
					end_row = end_row,
					start_col = start_col,
					end_col = end_col,
				})
			end
		elseif capture_name == "if.def" then
			-- Capture if __name__ == "__main__" blocks
			local text = vim.treesitter.get_node_text(node, bufnr)
			if text:match("__name__.*==.*[\"']__main__[\"']") or text:match("[\"']__main__[\"'].*==.*__name__") then
				local start_row, start_col, end_row, end_col = node:range()

				table.insert(scopes, {
					type = "block",
					name = 'if __name__ == "__main__"',
					start_row = start_row,
					end_row = end_row,
					start_col = start_col,
					end_col = end_col,
				})
			end
		end
	end

	-- Sort scopes by start position
	table.sort(scopes, function(a, b)
		if a.type == "buffer" then
			return true
		elseif b.type == "buffer" then
			return false
		end
		return a.start_row < b.start_row
	end)

	return scopes
end

-- Show fuzzy menu to select and send scope
function M.select_and_send_scope(filter_type)
	local scopes = M.get_scopes()

	-- Filter scopes by type if specified
	if filter_type then
		local filtered = {}
		for _, scope in ipairs(scopes) do
			if scope.type == filter_type then
				table.insert(filtered, scope)
			end
		end
		scopes = filtered
	end

	if #scopes == 0 then
		local msg = filter_type and ("No " .. filter_type .. "s found") or "No scopes found"
		vim.notify(msg, vim.log.levels.WARN)
		return
	end

	-- Create display items with line numbers and icons
	-- Add hidden text for type-based filtering (e.g., typing "function" will filter to functions)
	local items = {}
	for _, scope in ipairs(scopes) do
		local icon = M.icons[scope.type] or "?"
		local display
		if scope.type == "buffer" then
			display = string.format("%s %-40s %s", icon, scope.name, scope.type)
		else
			display = string.format(
				"%s %-40s [L%d-%d] %s",
				icon,
				scope.name,
				scope.start_row + 1,
				scope.end_row + 1,
				scope.type
			)
		end
		table.insert(items, display)
	end

	local prompt = filter_type and ("Select " .. filter_type .. " to send to IPython:")
		or "Select scope to send to IPython:"

	vim.ui.select(items, {
		prompt = prompt,
		format_item = function(item)
			return item
		end,
	}, function(choice, idx)
		if not choice then
			return
		end

		local scope = scopes[idx]
		local code = vim.api.nvim_buf_get_lines(0, scope.start_row, scope.end_row + 1, false)

		M.send_to_repl(code, nil, {
			start_line = scope.start_row + 1, -- Convert from 0-indexed to 1-indexed
			end_line = scope.end_row + 1,
		})

		vim.notify(string.format("Sent %s to IPython", scope.name), vim.log.levels.INFO)
	end)
end

vim.keymap.set("v", "<leader>r", M.run_selected_lines, { noremap = true, silent = true, desc = "Run in ipython" })

vim.keymap.set("n", "<leader>rr", M.run_current_line, { noremap = true, silent = true, desc = "Run line in ipython" })
vim.keymap.set("n", "<leader>rc", function()
	M.select_and_send_scope("class")
end, { noremap = true, silent = true, desc = "Select class to run in ipython" })

vim.keymap.set("n", "<leader>rf", function()
	M.select_and_send_scope("function")
end, { noremap = true, silent = true, desc = "Select function to run in ipython" })

vim.keymap.set("n", "<leader>rv", function()
	M.select_and_send_scope("variable")
end, { noremap = true, silent = true, desc = "Select variable to run in ipython" })

vim.keymap.set("n", "<leader>rb", function()
	M.select_and_send_scope("block")
end, { noremap = true, silent = true, desc = "Select block to run in ipython" })

vim.keymap.set("n", "<leader>rs", function()
	M.select_and_send_scope()
end, { noremap = true, silent = true, desc = "Select any scope to run in ipython" })

return M
