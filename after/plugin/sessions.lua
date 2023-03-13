require("session_manager").setup({
	-- Define what to do when Neovim is started without arguments.
	-- Possible values: Disabled, CurrentDir, LastSession
	autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
	autosave_last_session = true, -- Automatically save last session on exit and on session switch.
	autosave_only_in_session = true, -- If true, only autosaves after a session is active.
})
