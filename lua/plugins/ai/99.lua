return {
	"ThePrimeagen/99",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	opts = {
		model = "openai/gpt-5.3-codex",
		md_files = {
			"AGENTS.md",
		},
	},
	config = function(_, opts)
		require("99.utils").random_file = function()
			return string.format("/tmp/99-%d", math.floor(math.random() * 10000))
		end
		require("99").setup(opts)
	end,
	keys = {
		{
			"<leader>9v",
			function()
				require("99").visual()
			end,
			mode = "v",
			desc = "visual",
		},
		{
			"<leader>9x",
			function()
				require("99").stop_all_requests()
			end,
			mode = { "n", "v" },
			desc = "stop all",
		},
		{
			"<leader>9/",
			function()
				require("99").search()
			end,
			desc = "search",
		},
		{
			"<leader>9i",
			function()
				require("99").info()
			end,
			desc = "info",
		},
		{
			"<leader>9q",
			function()
				require("99").previous_requests_to_qfix()
			end,
			desc = "requests quickfix",
		},
		{
			"<leader>9c",
			function()
				require("99").clear_previous_requests()
			end,
			desc = "clear history",
		},
		{
			"<leader>9m",
			function()
				require("99").clear_all_marks()
			end,
			desc = "clear marks",
		},
		{
			"<leader>9l",
			function()
				require("99").view_logs()
			end,
			desc = "view logs",
		},
		{
			"[9",
			function()
				require("99").prev_request_logs()
			end,
			desc = "older log",
		},
		{
			"]9",
			function()
				require("99").next_request_logs()
			end,
			desc = "newer log",
		},
	},
}
