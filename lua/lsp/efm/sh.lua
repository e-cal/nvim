local M = {}

if Shell.formatter == 'shfmt' then
    local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}
    table.insert(M, shfmt)
end

if Shell.linter == 'shellcheck' then
    local shellcheck = {
        LintCommand = 'shellcheck -f gcc -x',
        lintFormats = {
            '%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m',
            '%f:%l:%c: %tote: %m'
        }
    }
    table.insert(M, shellcheck)
end

return M
