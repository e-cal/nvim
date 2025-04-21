return {
	{
		"frankroeder/parrot.nvim", -- https://github.com/frankroeder/dotfiles/blob/master/nvim/lua/plugins/parrot.lua
		config = function(_, opts)
			require("parrot").setup(opts)
		end,
		opts = {
			user_input_ui = "buffer", -- "native" | "buffer"
			chat_user_prefix = "### User",
			llm_prefix = "### Assistant: ",
			state_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/persisted",
			chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/parrot/chats",
			chat_free_cursor = true,
			chat_shortcut_respond = { modes = { "n" }, shortcut = "<cr>" },
			-- chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
			chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>" },
			-- chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
			hooks = {
				Ask = function(parrot, params)
					local template = [[
			                   In light of your existing knowledge base, please generate a response that
			                   is succinct and directly addresses the question posed. Prioritize accuracy
			                   and relevance in your answer, drawing upon the most recent information
			                   available to you. Aim to deliver your response in a concise manner,
			                   focusing on the essence of the inquiry.
			                   Question: {{command}}
			                 ]]
					local model_obj = parrot.get_model("command")
					parrot.logger.info("Asking model: " .. model_obj.name)
					parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "🤖 Ask ~ ", template)
				end,
			},
			providers = {
				ollama = {},
				openai = { api_key = os.getenv("OPENAI_API_KEY") },
				anthropic = {
					api_key = os.getenv("ANTHROPIC_API_KEY"),
					params = {
						command = { max_tokens = 4096 },
						chat = {
							max_tokens = 4096,
							thinking = { budget_tokens = 1024, type = "enabled" },
						},
					},
				},
				gemini = { api_key = os.getenv("GEMINI_API_KEY") },
				groq = { api_key = os.getenv("GROQ_API_KEY") },
				-- mistral = { api_key = os.getenv("MISTRAL_API_KEY") },
				-- pplx = { api_key = os.getenv("PERPLEXITY_API_KEY") },
				-- github = { api_key = os.getenv("GITHUB_TOKEN") },
				-- nvidia = { api_key = os.getenv("NVIDIA_API_KEY") },
				-- xai = { api_key = os.getenv("XAI_API_KEY") },
				custom = {
					style = "openai",
					api_key = os.getenv("RB_OPENROUTER_API_KEY"),
					endpoint = "https://openrouter.ai/api/v1/chat/completions",
					models = {
						"openrouter/auto",
						"openrouter/optimus-alpha",
						"openrouter/quasar-alpha",
						"cohere/command-a",
						"deepseek/deepseek-r1",
						"deepseek/deepseek-chat-v3-0324",
						"deepseek/deepseek-v3-base:free",
						"all-hands/openhands-lm-32b-v0.1",
						"google/gemini-2.5-pro-exp-03-25:free",
						"google/gemini-2.5-pro-preview-03-25",
						"google/gemini-2.0-flash-001",
						"x-ai/grok-3-beta",
						"x-ai/grok-3-mini-beta",
						"meta-llama/llama-4-maverick",
						"meta-llama/llama-4-maverick:free",
						"meta-llama/llama-3.1-405b-instruct",
						"nousresearch/hermes-3-llama-3.1-405b",
						"openai/o1-pro",
						"openai/o1-preview",
						"openai/o1-mini",
						"openai/o3-mini",
						"openai/o3-mini-high",
						"openai/gpt-4.5-preview",
						"google/gemini-2.0-pro-exp-02-05:free",
						"google/gemini-2.0-flash-thinking-exp:free",
						"google/gemma-3-27b-it",
					},
					topic = {
						model = "google/gemini-2.0-flash-001",
						params = { max_completion_tokens = 64 },
					},
					params = {
						chat = { temperature = 1 },
						command = { temperature = 1, top_p = 1 },
					},
				},
			},
		},
		keys = {
			{ "<leader>ar", ":PrtRewrite<cr>", desc = "rewrite", mode = "v" },
			{ "<leader>ae", ":PrtEdit<cr>", desc = "edit and rewrite", mode = "v" },
			{ "<leader>aj", ":PrtAppend<cr>", desc = "append code", mode = "v" },
			{ "<leader>ak", ":PrtPrepend<cr>", desc = "prepend code", mode = "v" },
			{ "<leader>ac", ":PrtChatToggle<cr>", desc = "toggle chat", mode = { "n", "v" } },
			{ "<leader>an", ":PrtChatNew<cr>", desc = "new chat", mode = { "n", "v" } },
			{ "<leader>ap", ":PrtChatPaste<cr>", desc = "paste to chat", mode = { "n", "v" } },
			{ "<leader>ai", "<cmd>PrtInfo<cr>", desc = "print plugin info" },
			{ "<leader>ax", "<cmd>PrtContext<cr>", desc = "edit context file" },
			{ "<leader>af", "<cmd>PrtChatFinder<cr>", desc = "find chat" },
			{ "<leader>ad", "<cmd>PrtChatDelete<cr>", desc = "delete chat" },
			{ "<leader>a<cr>", "<cmd>PrtChatRespond<cr>", desc = "trigger response" },
			{ "<leader>aq", "<cmd>PrtStop<cr>", desc = "stop response" },
			{ "<leader>am", "<cmd>PrtModel<cr>", desc = "switch model" },
			{ "<leader>aM", "<cmd>PrtProvider<cr>", desc = "switch provider" },
			{ "<leader>aS", "<cmd>PrtStatus<cr>", desc = "show status" },
			{ "<leader>at", "<cmd>PrtThinking<cr>", desc = "toggle thinking mode" },
			{ "<leader>aN", "<cmd>PrtNew<cr>", desc = "respond in new window" },
			{ "<leader>aB", "<cmd>PrtEnew<cr>", desc = "respond in new buffer" },
			{ "<leader>av", "<cmd>PrtVnew<cr>", desc = "respond in vsplit" },
			{ "<leader>aT", "<cmd>PrtTabnew<cr>", desc = "respond in new tab" },
			{ "<leader>aR", "<cmd>PrtRetry<cr>", desc = "retry last action" },
			{ "<leader>ai", "<cmd>PrtImplement<cr>", desc = "implement" },
			{ "<leader>a?", "<cmd>PrtAsk<cr>", desc = "ask a question" },
		},
	},
	{
		"yetone/avante.nvim",
		enabled = false,
		event = "VeryLazy",
		build = "make",
		opts = {
			provider = "claude",
			hints = { enabled = false },
			behavior = {
				enable_claude_text_editor_tool_mode = false,
			},
			mappings = {
				ask = "<leader>ca",
				refresh = "<leader>cr",
				edit = "<leader>ce", -- edit selection
				diff = {
					ours = "co",
					theirs = "ct",
					none = "cq",
					both = "cb",
					next = "]x",
					prev = "[x",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				toggle = {
					debug = "<leader>ad",
					hint = "<leader>ah",
				},
			},
		},
	},

	{
		"supermaven-inc/supermaven-nvim",
		opts = {
			disable_inline_completion = false,
			keymaps = {
				accept_suggestion = "<right>",
				clear_suggestion = "<C-k>",
				accept_word = "<C-j>",
				show_suggestion = "<C-l>",
			},
		},
		config = function(_, opts)
			require("supermaven-nvim").setup(opts)
			if opts.disable_inline_completion then
				local smvn = require("supermaven-nvim.completion_preview")
				local ns_id = vim.api.nvim_create_namespace("supermaven_custom")

				local function show_custom_suggestion()
					local buf = vim.api.nvim_get_current_buf()
					vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

					if not smvn.has_suggestion() then
						vim.notify("No suggestion available", vim.log.levels.INFO)
						return
					end

					local inlay_instance = smvn.inlay_instance
					if not inlay_instance or not inlay_instance.completion_text then
						vim.notify("No suggestion data found", vim.log.levels.INFO)
						return
					end

					local cursor = vim.api.nvim_win_get_cursor(0)
					local line = cursor[1] - 1
					local col = cursor[2]

					local completion_text = inlay_instance.completion_text
					local first_line = completion_text:match("^[^\n]*") or completion_text

					local _opts = {
						virt_text = { { first_line, "Comment" } },
						virt_text_pos = "eol", -- inline | eol
						hl_mode = "combine",
					}
					vim.api.nvim_buf_set_extmark(buf, ns_id, line, col, _opts)
					vim.b.supermaven_suggestion_shown = 1
					vim.notify("Suggestion displayed", vim.log.levels.INFO)
				end

				local function clear_custom_suggestion()
					local buf = vim.api.nvim_get_current_buf()
					vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
					vim.b.supermaven_suggestion_shown = 0
				end

				vim.keymap.set("i", opts.keymaps.show_suggestion, function()
					show_custom_suggestion()
				end, { noremap = true, silent = true })

				vim.keymap.set("i", opts.keymaps.clear_suggestion, function()
					clear_custom_suggestion()
					vim.notify("Suggestion cleared", vim.log.levels.INFO)
				end, { noremap = true, silent = true })

				vim.keymap.set("i", opts.keymaps.accept_suggestion, function()
					local svm = require("supermaven-nvim.completion_preview")
					if
						opts.disable_inline_completion
						or (not vim.b.supermaven_suggestion_shown or vim.b.supermaven_suggestion_shown == 0)
					then
						return vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes(opts.keymaps.accept_suggestion, true, false, true),
							"n",
							false
						)
					end
					svm.on_accept_suggestion(false)
					vim.b.supermaven_suggestion_shown = 0
					vim.notify("Suggestion accepted", vim.log.levels.INFO)
				end, { noremap = true, silent = true })

				vim.api.nvim_create_autocmd("TextChangedI", {
					group = vim.api.nvim_create_augroup("SupermavenClearSuggestion", { clear = true }),
					pattern = "*",
					callback = function()
						clear_custom_suggestion()
					end,
					desc = "Clear Supermaven suggestion on text change in insert mode",
				})

				vim.api.nvim_create_autocmd("ModeChanged", {
					group = vim.api.nvim_create_augroup("SupermavenClearSuggestion", { clear = false }),
					pattern = "i:*",
					callback = function()
						clear_custom_suggestion()
					end,
					desc = "Clear Supermaven suggestion on mode switch from insert mode",
				})
			end
		end,
	},
	{
		"e-cal/chat.nvim",
		dir = "~/projects/chat.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		opts = {
			auto_scroll = false,
			auto_format = false,
			default = {
				model = "sonnet-latest",
			},
			api_keys = {
				openrouter = function()
					return os.getenv("RB_OPENROUTER_API_KEY")
				end,
			},
		},
		keys = {
			{ "<leader>cc", "<cmd>ChatFocus<cr>", desc = "focus" },
			{ "<leader>ci", "<cmd>ChatInline<cr>", desc = "inline" },
			{ "<leader>cb", "<cmd>ChatInline base<cr>", desc = "inline (base)" },
			{ "<leader>c1", "<cmd>ChatInline o1<cr>", desc = "inline o1" },
			{ "<leader>cn", "<cmd>ChatNew<cr>", desc = "new chat" },
			{ "<leader>co", "<cmd>ChatOpen<cr>", desc = "open chat" },
			{ "<leader>cO", "<cmd>ChatOpen popup<cr>", desc = "open popup" },
			{ "<leader>ct", "<cmd>ChatToggle<cr>", desc = "toggle chat" },
			{ "<leader>ch", "<cmd>ChatResize 50<cr>", desc = "half screen" },
			{ "<leader>cR", "<cmd>ChatResize 30<cr>", desc = "restore size" },
			{ "<leader>cd", "<cmd>ChatDelete<cr>", desc = "delete chat" },
			{ "<leader>cf", "<cmd>ChatToggleFormatting<cr>", desc = "toggle formatting" },
			{ "<C-c>", "<cmd>ChatStop<cr>", desc = "stop generation" },
			-- visual
			{ "<leader>cc", "<cmd>ChatFocus<cr>", desc = "focus", mode = "v" },
			{ "<leader>ci", "<cmd>ChatInline<cr>", desc = "inline", mode = "v" },
			{ "<leader>cb", "<cmd>ChatInline base<cr>", desc = "inline (base)", mode = "v" },
			{ "<leader>cr", "<cmd>ChatReplace<cr>", desc = "replace inline", mode = "v" },
		},
	},
}
