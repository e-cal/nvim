local api = vim.api
Utils = {}

Utils.make_command = function(command, func)
    func = func or command
    local str = string.format("command! %s lua %s()", command, func)
    api.nvim_command(str)
end

