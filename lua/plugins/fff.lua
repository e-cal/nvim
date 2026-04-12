return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	-- build = "nix run .#release",
	opts = {
		title = "Files",
		prompt = "  ",
		layout = {
			path_shorten_strategy = "middle",
		},
	},
	config = function(_, opts)
		local fff = require("fff")
		fff.setup(opts)

		local default_file_renderer = require("fff.file_renderer")
		local fff_rust = require("fff.rust")
		local fff_conf = require("fff.conf")

		local function format_full_path(item, max_width)
			local path = item.relative_path or item.path or item.name or ""
			if type(path) ~= "string" then
				path = tostring(path)
			end

			local config = fff_conf.get()
			local strategy = config.layout and config.layout.path_shorten_strategy or "middle_number"
			return fff_rust.shorten_path(path, max_width, strategy), ""
		end

		local function with_full_path_formatter(ctx, fn)
			local original = ctx.format_file_display
			ctx.format_file_display = format_full_path
			local ok, result = pcall(fn)
			ctx.format_file_display = original
			if not ok then
				error(result)
			end
			return result
		end

		local full_path_renderer = {
			render_line = function(item, ctx, item_idx)
				return with_full_path_formatter(ctx, function()
					return default_file_renderer.render_line(item, ctx, item_idx)
				end)
			end,
			apply_highlights = function(item, ctx, item_idx, buf, ns_id, line_idx, line_content)
				return with_full_path_formatter(ctx, function()
					return default_file_renderer.apply_highlights(item, ctx, item_idx, buf, ns_id, line_idx, line_content)
				end)
			end,
		}

		local find_files_original = fff.find_files
		fff.find_files = function(find_opts)
			local merged_opts = vim.tbl_deep_extend("force", { renderer = full_path_renderer }, find_opts or {})
			return find_files_original(merged_opts)
		end

		local group = vim.api.nvim_create_augroup("FffEscBehavior", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = { "fff_input", "fff_list", "fff_preview" },
			callback = function(event)
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(event.buf) then
						return
					end

					vim.keymap.set("n", "<Esc>", function()
						require("fff.picker_ui").close()
					end, { buffer = event.buf, silent = true, desc = "Close fff" })

					if vim.bo[event.buf].filetype == "fff_input" then
						vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = event.buf, silent = true, desc = "Exit insert in fff" })
					end
				end)
			end,
		})
	end,
	lazy = false,
	keys = {
		{
			"ff",
			function()
				require("fff").find_files()
			end,
			desc = "files",
		},
		{
			"<leader>o",
			function()
				require("fff").find_files()
			end,
			desc = "files",
		},
		{
			"fg",
			function()
				require("fff").live_grep()
			end,
			desc = "live grep",
		},
		{
			"fz",
			function()
				require("fff").live_grep({
					grep = {
						modes = { "fuzzy", "plain" },
					},
				})
			end,
			desc = "fuzy grep",
		},
		{
			"fw",
			function()
				require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			end,
			desc = "search word",
		},
	},
}
