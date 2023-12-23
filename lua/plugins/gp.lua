local chat_prompt = "You are a coding expert assisting a colleague. When responding to their queries:\n\n"
	.. "- Ask question if you need clarification to provide better answer\n"
	.. "- Do not guess if you are unsure, ask for clarification or more context\n"
	.. "- Think deeply and carefully from first principles step by step\n"
	.. "- Call out mistakes or misconceptions, but only if they are relevant\n"
	.. "- Don't omit any code from your output if the answer requires coding\n"
	.. "- Take a deep breath before answering\n"
	.. "- Be terse and concise in your answer, you are both busy. Get to the point with minimal extraneous explanation unless asked to elaborate\n"
local cmd_prompt = "You are a super intelligent AI working as a code editor.\n\n"
	.. "AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
	.. "START AND END YOUR ANSWER WITH:\n\n```"

require("gp").setup({
	openai_api_key = { "cat", "/home/ecal/.cache/oai" },
	openai_api_endpoint = "https://api.openai.com/v1/chat/completions",
	agents = {
		{
			name = "ChatGPT4",
			chat = true,
			command = false,
			model = { model = "gpt-4-1106-preview", temperature = 0.5, top_p = 1 },
			system_prompt = chat_prompt,
		},
		{
			name = "ChatGPT3-5",
			chat = true,
			command = false,
			model = { model = "gpt-3.5-turbo-1106", temperature = 0.5, top_p = 1 },
			system_prompt = chat_prompt,
		},
		{
			name = "CodeGPT4",
			chat = false,
			command = true,
			model = { model = "gpt-4-1106-preview", temperature = 0.5, top_p = 1 },
			system_prompt = cmd_prompt,
		},
		{
			name = "CodeGPT3-5",
			chat = false,
			command = true,
			model = { model = "gpt-3.5-turbo-1106", temperature = 0.5, top_p = 1 },
			system_prompt = cmd_prompt,
		},
	},
	chat_user_prefix = "󰭹 :",
	chat_assistant_prefix = { "󰚩 :", "[{{agent}}]" },
	chat_shortcut_respond = { modes = { "n" }, shortcut = "<cr>" },
	chat_shortcut_delete = { modes = { "n" }, shortcut = "<leader>gd" },
	chat_shortcut_stop = { modes = { "n" }, shortcut = "<leader>gq" },
	chat_shortcut_new = { modes = { "n" }, shortcut = "<leader>gn" },
	toggle_target = "split",
	chat_conceal_model_params = false,
	chat_confirm_delete = false,
    whisper_dir = "/tmp",
    image_dir = "/tmp",

})
