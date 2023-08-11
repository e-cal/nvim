if vim.g.vscode then
else
	dofile(os.getenv("HOME") .. "/.config/nvim/settings.lua")
	require("utils")
	require("plugins")
	require("keymap")
	require("vim-settings")
	require("functions")
	require("auto")
	require("colors")

	-- LSP
	require("lsp")

    -- Plugins
    require("plugins.packer_compiled")
    for _, file in ipairs(vim.fn.readdir(os.getenv("HOME") .. "/.config/nvim/lua/plugins")) do
        if string.match(file, ".lua") and not string.match(file, "packer_compiled") then
            require("plugins." .. string.gsub(file, ".lua", ""))
        end
    end
end
