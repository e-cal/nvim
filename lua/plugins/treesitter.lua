return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/playground",
	},
	opts = {
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "markdown", "markdown_inline" },
		sync_install = false,
		auto_install = true,
		ignore_install = {},
		highlight = {
			enable = true,
			disable = function(lang, buf)
				-- might also want to disable comment highlight altogether?
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			additional_vim_regex_highlighting = false,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "vs",
				node_incremental = "n",
				scope_incremental = "gs",
				node_decremental = "P",
			},
		},
		indent = { enable = true },
		textobjects = {
			move = {
				enable = true,
				set_jumps = false,
				goto_next_start = {
					["]b"] = { query = "@block.inner", desc = "next block" },
				},
				goto_previous_start = {
					["[b"] = { query = "@block.inner", desc = "previous block" },
				},
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ib"] = "@block.inner",
					["ab"] = "@block.outer",
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				include_surrounding_whitespace = true,
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
