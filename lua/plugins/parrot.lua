return {
		"e-cal/parrot.nvim",
        enabled = false,
		-- dir = "~/projects/parrot.nvim",
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
            command_auto_select_response = true,
            highlight_response = false,
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
				anthropic = {
					name = "anthropic",
					endpoint = "https://api.anthropic.com/v1/messages",
					model_endpoint = "https://api.anthropic.com/v1/models",
					api_key = os.getenv("ANTHROPIC_API_KEY"),
					params = {
						chat = { max_tokens = 4096 },
						command = { max_tokens = 4096 },
					},
					topic = {
						model = "claude-3-5-haiku-latest",
						params = { max_tokens = 32 },
					},
					headers = function(self)
						return {
							["Content-Type"] = "application/json",
							["x-api-key"] = self.api_key,
							["anthropic-version"] = "2023-06-01",
						}
					end,
					models = {
						"claude-sonnet-4-20250514",
						"claude-3-7-sonnet-20250219",
						"claude-3-5-sonnet-20241022",
						"claude-3-5-haiku-20241022",
					},
					preprocess_payload = function(payload)
						for _, message in ipairs(payload.messages) do
							message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
						end
						if payload.messages[1] and payload.messages[1].role == "system" then
							-- remove the first message that serves as the system prompt as anthropic
							-- expects the system prompt to be part of the API call body and not the messages
							payload.system = payload.messages[1].content
							table.remove(payload.messages, 1)
						end
						return payload
					end,
				},
				openrouter = {
					name = "openrouter",
					-- style = "openai",
					api_key = os.getenv("OPENROUTER_API_KEY"),
					endpoint = "https://openrouter.ai/api/v1/chat/completions",
					-- model_endpoint = "https://openrouter.ai/api/v1/models",
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
						"google/gemini-2.5-flash-preview-05-20:thinking",
						"google/gemini-2.5-flash-preview-05-20",
						"google/gemini-2.5-pro-preview",
						"google/gemini-2.0-flash-001",
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
						model = "google/gemini-2.5-flash-preview-05-20",
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
			{ "<leader>Pj", ":PAppend<cr>", desc = "append code", mode = { "n", "v" } },
			{ "<leader>Pk", ":PPrepend<cr>", desc = "prepend code", mode = { "n", "v" } },
			{ "<leader>Pr", ":PRewriteWithContext<cr>", desc = "rewrite", mode = "v" },
			{ "<leader>PR", ":PRewrite<cr>", desc = "rewrite (no context)", mode = "v" },
			{ "<leader>Pi", ":PImplementWithContext<cr>", desc = "implement", mode = "v" },
			{ "<leader>Pi", "V:PImplementWithContext<cr>", desc = "implement", mode = "n" },
			{ "<leader>PI", ":PImplement<cr>", desc = "implement (no context)", mode = "v" },
			{ "<leader>PI", "V:PImplement<cr>", desc = "implement (no context)", mode = "n" },
			{ "<leader>Pe", ":PEdit<cr>", desc = "edit", mode = "v" },
			{ "<leader>Pc", ":PComplete<cr>", desc = "complete", mode = "v" },
			{ "<leader>Pc", "V:PComplete<cr>", desc = "complete", mode = "n" },
			{ "<leader>Ps", ":PCompleteSelection<cr>", desc = "complete (selection only)", mode = "v" },
			{ "<leader>PC", ":PCompleteFullContext<cr>", desc = "complete (all buffers)", mode = "v" },
			{ "<leader>PC", "V:PCompleteFullContext<cr>", desc = "complete (all buffers)", mode = "n" },

			{ "<leader>Pt", ":PChatToggle<cr>", desc = "toggle chat", mode = { "n", "v" } },
			{ "<leader>Pn", ":PChatNew<cr>", desc = "new chat", mode = { "n", "v" } },
			{ "<leader>Pp", ":PChatPaste<cr>", desc = "paste to chat", mode = "v" },

			{ "<leader>Ph", "<cmd>PErrorHandling<cr>", desc = "add error handling" },
			{ "<leader>PI", "<cmd>PInfo<cr>", desc = "print plugin info" },
			{ "<leader>Px", "<cmd>PContext<cr>", desc = "edit context file" },
			{ "<leader>Pf", "<cmd>PChatFinder<cr>", desc = "find chat" },
			{ "<leader>Pd", "<cmd>PChatDelete<cr>", desc = "delete chat" },
			{ "<leader>P<cr>", "<cmd>PChatRespond<cr>", desc = "trigger response" },
			{ "<leader>Pq", "<cmd>PStop<cr>", desc = "stop response" },
			{ "<leader>Pm", "<cmd>PModel<cr>", desc = "switch model" },
			{ "<leader>PM", "<cmd>PProvider<cr>", desc = "switch provider" },
			{ "<leader>PS", "<cmd>PStatus<cr>", desc = "show status" },
			{ "<leader>Pt", "<cmd>PThinking<cr>", desc = "toggle thinking mode" },
			{ "<leader>PN", "<cmd>PNew<cr>", desc = "respond in new window" },
			{ "<leader>PR", "<cmd>PRetry<cr>", desc = "retry last action" },
			{ "<leader>P?", "<cmd>PAsk<cr>", desc = "ask a question" },
		},
	}
