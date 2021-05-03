local M = {}

if Python.formatter == 'black' then
    local black = {formatCommand = "black --fast -", formatStdin = true}
    table.insert(M, black)
elseif Python.formatter == 'yapf' then
    local yapf = {formatCommand = "yapf --quiet", formatStdin = true}
    table.insert(M, yapf)
end

if Python.isort then
    local isort = {formatCommand = "isort --quiet -", formatStdin = true}
    table.insert(M, isort)
end

if Python.linter == 'flake8' then
    local flake8 = {
        lintCommand = "flake8 --max-line-length 160 --stdin-display-name ${INPUT} -",
        lintStdin = true,
        lintIgnoreExitCode = true,
        lintFormats = {"%f:%l:%c: %t%m"},
        lintSource = "flake8",
    }
    table.insert(M, flake8)
end

return M
