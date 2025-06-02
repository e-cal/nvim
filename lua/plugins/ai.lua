return {
	{
		"frankroeder/parrot.nvim",
		config = function(_, opts)
			require("parrot").setup(opts)
		end,
		opts = {
			cmd_prefix = "P",
			user_input_ui = "buffer",
			command_prompt_prefix_template = "Instruction ",
			chat_user_prefix = "### User",
			llm_prefix = "### Assistant",
			chat_free_cursor = true,
			system_prompt = {
				command = [[
                    <context>
                    You are an expert programming AI assistant who prioritizes minimalist, efficient code. 
                    You write idiomatic solutions, seek clarification when needed (via code comments), and accept user preferences even if suboptimal.
                    Your responses stricly pertain to the code provided, focused on the snippet in question.
                    </context>

                    <format_rules>
                    - Match the style of user written code
                    - Comment sparingly, only to explain large & complex code blocks
                    - Always use type annotations on functions when writing python (use 3.12 style builtin types rather than importing from typing)
                    </format_rules>

                    Respond following these rules. Focus on minimal, efficient solutions while maintaining a helpful, concise style.
                ]],
			},
			hooks = {
				--[[
                              Placeholders
                {{selection}} 	        Current visual selection
                {{filetype}} 	        Filetype of the current buffer
                {{filename}} 	        Filename of the current buffer
                {{filepath}} 	        Full path of the current file
                {{filecontent}} 	    Full content of the current buffer
                {{multifilecontent}} 	Full content of all open buffers
                {{command}} 	        User command (prompt)
                --]]
				RewriteWithContext = function(prt, params)
					local template = [[
                        I have the following code from {{filename}}:

                        ```{{filetype}}
                        {{filecontent}}
                        ```

                        Please look at the following section specifically:
                        ```{{filetype}}
                        {{selection}}
                        ```

                        {{command}}
                        Respond exclusively with the snippet that should replace the selection above.
                    ]]
					local model_obj = prt.get_model("command")
					prt.Prompt(params, prt.ui.Target.rewrite, model_obj, "Instruction ", template)
				end,
				ImplementWithContext = function(prt, params)
					local template = [[
                        I have the following code from {{filename}}:

                        ```{{filetype}}
                        {{filecontent}}
                        ```

                        Please look at the following section specifically:
                        ```{{filetype}}
                        {{selection}}
                        ```

                        Please rewrite this according to the contained instructions.
                        Respond exclusively with the snippet that should replace the selection above.
                    ]]
					local model_obj = prt.get_model("command")
					prt.Prompt(params, prt.ui.Target.rewrite, model_obj, nil, template)
				end,
				CompleteSelection = function(prt, params)
					local template = [[
                        I have the following code from {{filename}}:

                        ```{{filetype}}
                        {{selection}}
                        ```

                        Please finish the code above carefully and logically. Follow any instructions in the comments.
                        Respond just with the snippet of code that should be inserted.
                    ]]
					local model_obj = prt.get_model("command")
					prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
				end,
				Complete = function(prt, params)
					local template = [[
                        I have the following code from {{filename}}:

                        ```{{filetype}}
                        {{filecontent}}
                        ```

                        Please look at the following section specifically and follow any instructions in the comments:
                        ```{{filetype}}
                        {{selection}}
                        ```

                        Please finish the code above carefully and logically.
                        Respond just with the snippet of code that should be inserted.
                    ]]
					local model_obj = prt.get_model("command")
					prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
				end,
				CompleteFullContext = function(prt, params)
					local template = [[
                        I have the following code from {{filename}} and other realted files:

                        ```{{filetype}}
                        {{multifilecontent}}
                        ```

                        Please look at the following section specifically:
                        ```{{filetype}}
                        {{selection}}
                        ```

                        Please finish the code above carefully and logically.
                        Respond just with the snippet of code that should be inserted.
                    ]]
					local model_obj = prt.get_model("command")
					prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
				end,
				ErrorHandling = function(prt, params)
					local template = [[
                        You are a {{filetype}} expert.
                        Review the following code, carefully examine it, and update it to have robust error handling.
                        Prefer to pass errors on to the caller and use minimal try/catch blocks.

                        ```{{filetype}}
                        {{filecontent}}
                        ```
                    ]]
					local model_obj = prt.get_model("command")
					prt.logger.info("Adding error handling with: " .. model_obj.name)
					prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
				end,
			},
			providers = {
				-- ollama = {},
				-- openai = {
				-- 	name = "openai",
				-- 	endpoint = "https://api.openai.com/v1/chat/completions",
				-- 	api_key = os.getenv("OPENAI_API_KEY"),
				-- },
				-- anthropic = {
				-- 	name = "anthropic",
				-- 	endpoint = "https://api.anthropic.com/v1/messages",
				-- 	model_endpoint = "https://api.anthropic.com/v1/models",
				-- 	api_key = os.getenv("ANTHROPIC_API_KEY"),
				-- 	params = {
				-- 		command = { max_tokens = 4096 },
				-- 		chat = {
				-- 			max_tokens = 4096,
				-- 			thinking = { budget_tokens = 1024, type = "enabled" },
				-- 		},
				-- 	},
				-- },
				-- gemini = {
				-- 	name = "gemini",
				-- 	endpoint = function(self)
				-- 		return "https://generativelanguage.googleapis.com/v1beta/models/"
				-- 			.. self._model
				-- 			.. ":streamGenerateContent?alt=sse"
				-- 	end,
				-- 	model_endpoint = function(self)
				-- 		return { "https://generativelanguage.googleapis.com/v1beta/models?key=" .. self.api_key }
				-- 	end,
				-- 	api_key = os.getenv("GEMINI_API_KEY"),
				-- },
				custom = {
                    name = "openrouter",
					style = "openai",
					api_key = os.getenv("OPENROUTER_API_KEY"),
					endpoint = "https://openrouter.ai/api/v1/chat/completions",
					models = {
						"openrouter/auto",
						"cohere/command-a",
						"deepseek/deepseek-r1",
						"deepseek/deepseek-chat-v3-0324",
						"deepseek/deepseek-v3-base:free",
                        "deepseek/deepseek-r1-0528",
                        "deepseek/deepseek-prover-v2",
						"x-ai/grok-3-beta",
						"x-ai/grok-3-mini-beta",
						"google/gemini-2.5-pro-exp-03-25:free",
						"google/gemini-2.5-pro-preview-03-25",
						"google/gemini-2.0-flash-001",
						"google/gemini-2.0-pro-exp-02-05:free",
						"google/gemini-2.0-flash-thinking-exp:free",
						"google/gemini-2.5-flash-preview",
						"google/gemma-3-27b-it",
						"openai/o1-pro",
						"openai/o1-preview",
						"openai/o1-mini",
						"openai/o3-mini",
						"openai/o3-mini-high",
						"openai/gpt-4.5-preview",
                        "anthropic/claude-sonnet-4",
                        "anthropic/claude-opus-4",
                        "anthropic/claude-3.7-sonnet",
                        "anthropic/claude-3.7-sonnet:thinking",
                        "anthropic/claude-3.5-sonnet",
                        "anthropic/claude-3.5-haiku",
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
			chat_shortcut_respond = { modes = { "n" }, shortcut = "<cr>" },
			chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>" },
		},
		keys = {
			{ "<leader>aj", ":PAppend<cr>", desc = "append code", mode = { "n", "v" } },
			{ "<leader>ak", ":PPrepend<cr>", desc = "prepend code", mode = { "n", "v" } },
			{ "<leader>ar", ":PRewriteWithContext<cr>", desc = "rewrite", mode = "v" },
			{ "<leader>aR", ":PRewrite<cr>", desc = "rewrite (no context)", mode = "v" },
			{ "<leader>ai", ":PImplementWithContext<cr>", desc = "implement", mode = "v" },
			{ "<leader>ai", "V:PImplementWithContext<cr>", desc = "implement", mode = "n" },
			{ "<leader>aI", ":PImplement<cr>", desc = "implement (no context)", mode = "v" },
			{ "<leader>aI", "V:PImplement<cr>", desc = "implement (no context)", mode = "n" },
			{ "<leader>ae", ":PEdit<cr>", desc = "edit", mode = "v" },
			{ "<leader>ac", ":PComplete<cr>", desc = "complete", mode = "v" },
			{ "<leader>ac", "V:PComplete<cr>", desc = "complete", mode = "n" },
			{ "<leader>as", ":PCompleteSelection<cr>", desc = "complete (selection only)", mode = "v" },
			{ "<leader>aC", ":PCompleteFullContext<cr>", desc = "complete (all buffers)", mode = "v" },
			{ "<leader>aC", "V:PCompleteFullContext<cr>", desc = "complete (all buffers)", mode = "n" },

			{ "<leader>at", ":PChatToggle<cr>", desc = "toggle chat", mode = { "n", "v" } },
			{ "<leader>an", ":PChatNew<cr>", desc = "new chat", mode = { "n", "v" } },
			{ "<leader>ap", ":PChatPaste<cr>", desc = "paste to chat", mode = "v" },

			{ "<leader>ah", "<cmd>PErrorHandling<cr>", desc = "add error handling" },
			{ "<leader>aI", "<cmd>PInfo<cr>", desc = "print plugin info" },
			{ "<leader>ax", "<cmd>PContext<cr>", desc = "edit context file" },
			{ "<leader>af", "<cmd>PChatFinder<cr>", desc = "find chat" },
			{ "<leader>ad", "<cmd>PChatDelete<cr>", desc = "delete chat" },
			{ "<leader>a<cr>", "<cmd>PChatRespond<cr>", desc = "trigger response" },
			{ "<leader>aq", "<cmd>PStop<cr>", desc = "stop response" },
			{ "<leader>am", "<cmd>PModel<cr>", desc = "switch model" },
			{ "<leader>aM", "<cmd>PProvider<cr>", desc = "switch provider" },
			{ "<leader>aS", "<cmd>PStatus<cr>", desc = "show status" },
			{ "<leader>at", "<cmd>PThinking<cr>", desc = "toggle thinking mode" },
			{ "<leader>aN", "<cmd>PNew<cr>", desc = "respond in new window" },
			{ "<leader>aR", "<cmd>PRetry<cr>", desc = "retry last action" },
			{ "<leader>a?", "<cmd>PAsk<cr>", desc = "ask a question" },
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
					return os.getenv("OPENROUTER_API_KEY")
				end,
			},
			model_maps = {
				openrouter = {
					-- openai
					["gpt-4o"] = "openai/gpt-4o",
					["gpt-4.1"] = "openai/gpt-4.1",
					["gpt-4.5"] = "openai/gpt-4.5-preview",
					["o1"] = "openai/o1",
					["o1-pro"] = "openai/o1-pro",
					["o1-mini"] = "openai/o1-mini",
					["o3-mini"] = "openai/o3-mini",
					["o3-mini-high"] = "openai/o3-mini-high",
					["o3"] = "openai/o3",
					["o4-mini"] = "openai/o4-mini",
					-- claude
					["opus"] = "anthropic/claude-opus-4",
					["sonnet-4"] = "anthropic/claude-sonnet-4",
					["sonnet-3.7"] = "anthropic/claude-3.7-sonnet",
				},
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
