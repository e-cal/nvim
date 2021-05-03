local M = {}

if Lua.formatter == 'lua-format' then
    local lua_format = {
        formatCommand = "lua-format -i --no-keep-simple-function-one-line --column-limit=" ..
            Lua.formatLineLength,
        formatStdin = true
    }
    table.insert(M, lua_format)
end

return M
