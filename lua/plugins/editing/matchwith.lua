return {
	"tar80/matchwith.nvim", -- bracket pair matching
	-- Pinned to the reviewed commit; review upstream changes before bumping.
	commit = "70bde09e0c1c89375b1fd89a6800973fe8798ec6",
	event = "VeryLazy",
	enabled = function()
		local max_filesize = 100 * 1024 -- 100 KB
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(0))
		if ok and stats and stats.size > max_filesize then
			print("disabled matchwith (bracket matching) for large file")
			return false
		end
		return true
	end,
	config = function()
		require("matchwith").setup({ show_parent = true })

		-- Highlight the pair under the cursor and the pair around the cursor
		-- the same way. Reapply after a colorscheme change clears them.
		local function set_highlights()
			local hl = { fg = Utils.get_hl("Constant", "fg"), bg = Utils.get_hl("Normal", "bg"), bold = true }
			for _, group in ipairs({ "MatchParen", "Matchwith", "MatchwithParent" }) do
				vim.api.nvim_set_hl(0, group, hl)
			end
		end
		set_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })
	end,
}
