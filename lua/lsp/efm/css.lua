local M = {}

local stylelint = {
    lintCommand = 'stylelint --stdin --stdin-filename ${INPUT} --formatter compact',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {
        '%f: line %l, col %c, %tarning - %m', '%f: line %l, col %c, %trror - %m'
    }
}

table.insert(M, stylelint)

local prettier = {
    formatCommand = string.format(
        "prettier --stdin --stdin-filepath ${INPUT} --tab-width %s", TabSize),
    formatStdin = true
}

table.insert(M, prettier)

return M
