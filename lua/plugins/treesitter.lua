return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	dependencies = {
		-- Must use main branch to match nvim-treesitter's new API
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			config = function()
				local select = require("nvim-treesitter-textobjects.select")
				local move = require("nvim-treesitter-textobjects.move")

				require("nvim-treesitter-textobjects").setup({
					select = {
						lookahead = true,
						selection_modes = {
							["@parameter.outer"] = "v",
							["@function.outer"] = "V",
							["@class.outer"] = "<c-v>",
						},
						include_surrounding_whitespace = true,
					},
					move = {
						set_jumps = false,
					},
				})

				-- Select keymaps
				vim.keymap.set({ "x", "o" }, "af", function()
					select.select_textobject("@function.outer", "textobjects")
				end, { desc = "outer function" })
				vim.keymap.set({ "x", "o" }, "if", function()
					select.select_textobject("@function.inner", "textobjects")
				end, { desc = "inner function" })
				vim.keymap.set({ "x", "o" }, "as", function()
					select.select_textobject("@local.scope", "locals")
				end, { desc = "language scope" })
				vim.keymap.set({ "x", "o" }, "i`", function()
					select.select_textobject("@block.inner", "textobjects")
				end, { desc = "inner block" })
				vim.keymap.set({ "x", "o" }, "a`", function()
					select.select_textobject("@block.outer", "textobjects")
				end, { desc = "outer block" })

				-- Move keymaps
				vim.keymap.set({ "n", "x", "o" }, "]b", function()
					move.goto_next_start("@block.inner", "textobjects")
				end, { desc = "next block" })
				vim.keymap.set({ "n", "x", "o" }, "[b", function()
					move.goto_previous_start("@block.inner", "textobjects")
				end, { desc = "previous block" })
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				max_lines = 0,
				trim_scope = "inner",
				multiline_threshold = 1,
			},
		},
	},
	config = function()
		-- nvim-treesitter main branch uses vim.treesitter directly
		-- Parsers are auto-installed when needed, configure via vim.treesitter
		vim.treesitter.language.register("markdown", "mdx")

		-- Ensure commonly used parsers are available
		local ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"python",
			"markdown",
			"markdown_inline",
		}

		-- Install missing parsers
		for _, lang in ipairs(ensure_installed) do
			pcall(function()
				if not pcall(vim.treesitter.language.inspect, lang) then
					vim.cmd("TSInstall " .. lang)
				end
			end)
		end

		-- Configure highlight (enabled by default in nvim 0.10+)
		-- Large file handling
		vim.api.nvim_create_autocmd("BufReadPre", {
			callback = function(args)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.uv.fs_stat, args.file)
				if ok and stats and stats.size > max_filesize then
					vim.treesitter.stop(args.buf)
					print("Disabled treesitter for large file")
				end
			end,
		})

		-- Incremental selection keymaps
		vim.keymap.set("n", "vs", function()
			require("nvim-treesitter.incremental_selection").init_selection()
		end, { desc = "Start incremental selection" })
		vim.keymap.set("x", "n", function()
			require("nvim-treesitter.incremental_selection").node_incremental()
		end, { desc = "Increment selection" })
		vim.keymap.set("x", "gs", function()
			require("nvim-treesitter.incremental_selection").scope_incremental()
		end, { desc = "Increment scope" })
		vim.keymap.set("x", "P", function()
			require("nvim-treesitter.incremental_selection").node_decremental()
		end, { desc = "Decrement selection" })

		local function get_python_cell()
			local bufnr = vim.api.nvim_get_current_buf()
			local language_tree = vim.treesitter.get_parser(bufnr, "python")
			local syntax_tree = language_tree:parse()
			local root = syntax_tree[1]:root()
			local query = vim.treesitter.query.parse("python", [[ ((comment) @cell.start (#eq? @cell.start "# %%")) ]])

			local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
			local cells = {}
			local last_start = 0

			for id, node in query:iter_captures(root, bufnr) do
				local start_row = node:start()
				if #cells > 0 then
					cells[#cells].end_row = start_row - 1
				end
				table.insert(cells, { start_row = start_row, end_row = nil })
				last_start = start_row
			end

			-- Set the end of the last cell to the end of the file
			if #cells > 0 then
				cells[#cells].end_row = vim.api.nvim_buf_line_count(bufnr) - 1
			end

			local current_cell
			for i, cell in ipairs(cells) do
				if cursor_row >= cell.start_row and (i == #cells or cursor_row < cells[i + 1].start_row) then
					current_cell = cell
					break
				end
			end

			if current_cell then
				local start_row = current_cell.start_row
				local end_row = current_cell.end_row

				-- Ignore blank lines at the end
				while end_row > start_row do
					local line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1]
					if line:match("^%s*$") then
						end_row = end_row - 1
					else
						break
					end
				end

				return start_row, end_row
			end

			return nil, nil
		end

		vim.api.nvim_create_user_command("SelectPythonCell", function(_opts)
			local start_row, end_row = get_python_cell()

			if start_row and end_row then
				if _opts.args == "content" then
					start_row = start_row + 1
				end

				vim.api.nvim_win_set_cursor(0, { start_row + 1, 0 })
				vim.cmd("normal! V")
				vim.api.nvim_win_set_cursor(0, { end_row + 1, 0 })
			else
				print("No cell found at cursor position")
			end
		end, { nargs = "?" })

		vim.api.nvim_set_keymap("n", "gC", "<cmd>SelectPythonCell<CR>", { noremap = true, silent = true })
		-- vim.api.nvim_set_keymap(
		-- 	"n",
		-- 	"<leader>pc",
		-- 	"<cmd>SelectPythonCell content<CR>",
		-- 	{ noremap = true, silent = true }
		-- )

		function make_cell_textobject(include_delimiter)
			return function()
				local start_row, end_row = get_python_cell()
				if start_row and end_row then
					if not include_delimiter then
						start_row = start_row + 1
					end

					-- Get the last column of the end row
					local end_col = vim.fn.col({ end_row + 1, "$" }) - 1

					vim.fn.setpos("'<", { 0, start_row + 1, 1, 0 })
					vim.fn.setpos("'>", { 0, end_row + 1, end_col, 0 })

					-- Use 'normal! gv' only if we're not already in visual mode
					local mode = vim.api.nvim_get_mode().mode
					if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
						vim.cmd("normal! gv")
					end
				end
			end
		end
		-- Define the text objects
		vim.api.nvim_set_keymap(
			"x",
			"ic",
			":<C-u>lua make_cell_textobject(false)()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"o",
			"ic",
			":<C-u>lua make_cell_textobject(false)()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"x",
			"ac",
			":<C-u>lua make_cell_textobject(true)()<CR>",
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"o",
			"ac",
			":<C-u>lua make_cell_textobject(true)()<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
