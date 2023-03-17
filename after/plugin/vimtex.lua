local map = vim.keymap.set

vim.g.vimtex_view_method = "zathura"

map("n", "dse", "<Plug>(vimtex-env-delete)")
map("n", "cse", "<Plug>(vimtex-env-change)")
map("n", "dsc", "<Plug>(vimtex-cmd-delete)")
map("n", "csc", "<Plug>(vimtex-cmd-change)")
map("n", "dsd", "<Plug>(vimtex-delim-delete)")
map("n", "csd", "<Plug>(vimtex-delim-change)")
map("n", "ds$", "<Plug>(vimtex-env-delete-math)")
map("n", "cs$", "<Plug>(vimtex-env-change-math)")

map("n", "tsc", "<Plug>(vimtex-cmd-toggle-star)")
map("n", "tse", "<Plug>(vimtex-env-toggle-star)")
map("n", "ts$", "<Plug>(vimtex-env-toggle-math)")
map("n", "tsd", "<Plug>(vimtex-delim-toggle-modifier)")
map("n", "tsD", "<Plug>(vimtex-delim-toggle-modifier-reverse)")
map("n", "tsf", "<Plug>(vimtex-cmd-toggle-frac)")

--[[

%  - navigate matching content
[[ - navigate sections
]m - navigate environments
]n - navigate math blocks
]r - navigate beamer frames (slides using beamer doc class)


Mapping	    Text object
ac, ic	    LaTeX commands
ad, id	    Paired delimiters
ae, ie	    LaTeX environments
a$, i$	    Inline math
aP, iP	    Sections
am, im	    Items in itemize and enumerate environments

]]
