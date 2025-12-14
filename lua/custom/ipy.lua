local M = {}
local curl = require("plenary.curl")

M.config = {
	url = "http://localhost:5000/execute",
}

function M.setup(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
end

function M.send_to_repl(code)
    if type(code) == "table" and #code > 0 then
        -- Get current buffer's file path relative to cwd
        local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
        local start_line, end_line

        -- Get the visual selection line range
        if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
            local _, srow = unpack(vim.fn.getpos('v'))
            local _, erow = unpack(vim.fn.getpos('.'))
            start_line = math.min(srow, erow)
            end_line = math.max(srow, erow)
        else
            -- For current line or other operations
            start_line = vim.fn.line('.')
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

    local response = curl.post(M.config.url, {
        body = vim.fn.json_encode({ code = code }),
        headers = {
            content_type = "application/json",
        },
    })
    local result = vim.fn.json_decode(response.body)
end

function M.get_visual_selection()
    local _, srow, scol = unpack(vim.fn.getpos 'v')
    local _, erow, ecol = unpack(vim.fn.getpos '.')

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
    local line = vim.api.nvim_buf_get_lines(0, vim.fn.line('.') - 1, vim.fn.line('.'), true)
    M.send_to_repl(line)
end


vim.keymap.set(
	"v",
	"<leader>r",
	M.run_selected_lines,
	{ noremap = true, silent = true, desc = "Run in ipython" }
)

vim.keymap.set(
    "n",
    "<leader>rr",
    M.run_current_line,
    { noremap = true, silent = true, desc = "Run line in ipython" }
)
vim.keymap.set(
    "n",
    "<leader>rc",
    function()
        vim.api.nvim_command("SelectPythonCell")
        M.run_selected_lines()
    end,
    { noremap = true, silent = true, desc = "Run cell in ipython" }
)
vim.keymap.set(
    "n",
    "<leader>rf",
    function()
        -- mark location, select function (vaf keybind), run, return to mark
        vim.api.nvim_command("normal! m'")
        vim.api.nvim_feedkeys("vaf", "x", false)
        M.run_selected_lines()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
        vim.api.nvim_command("normal! g`'")
    end,
    { noremap = true, silent = true, desc = "Run function" }
)

return M
