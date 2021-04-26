" Timeout
let g:which_key_timeout = 500
let g:which_key_use_floating_win = 1
let g:which_key_disable_default_offset = 0

" Hide status line
" autocmd! FileType which_key
" autocmd  FileType which_key set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

let g:which_key_display_names = {'<CR>': '↵', '<TAB>': '⇆', ' ': '⎵'}
let g:which_key_sep = '→'

" Map leader to which_key
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map =  {}

let g:which_key_map['f'] = [ ':Telescope find_files', 'find files' ]
let g:which_key_map['H'] = [ ':Dashboard', 'home' ]
let g:which_key_map['/'] = [ ':CommentToggle', 'toggle comment' ]
let g:which_key_map['?'] = [ ':NvimTreeFindFile', 'find current file' ]
let g:which_key_map['e'] = [ ':NvimTreeToggle', 'explorer' ]
let g:which_key_map['s'] = [ ':w', 'save' ]
let g:which_key_map['q'] = [ ':wqa', 'quit' ]
let g:which_key_map['w'] = [ ':q', 'close window' ]
let g:which_key_map['x'] = [ ':BufferClose', 'close buffer' ]
let g:which_key_map['.'] = [ ':luafile %', 'source file' ]
let g:which_key_map['h'] = [ ':sp', 'split below' ]
let g:which_key_map['v'] = [ ':sp', 'split right' ]

let g:which_key_map.b = {
      \ 'name' : '+buffer',
      \ '>' : [':BufferMoveNext', 'move right'],
      \ '<' : [':BufferMovePrevious', 'move left'],
      \ 'b' : [':BufferPick', 'pick buffer'],
      \ 'c' : [':BufferClose', 'close buffer'],
      \ 'n' : [':bnext', 'next buffer'],
      \ 'p' : [':bprevious', 'prev buffer']
      \ }

let g:which_key_map.d = {
      \ 'name' : '+debug' ,
      \ 'b' : [':DebugToggleBreakpoint', 'toggle breakpoint'],
      \ 'c' : [':DebugContinue', 'continue'],
      \ 'i' : [':DebugStepInto', 'step into'],
      \ 'o' : [':DebugStepOver', 'step over'],
      \ 'r' : [':DebugToggleRepl', 'toggle repl'],
      \ 's' : [':DebugStart', 'start'],
      \ }

let g:which_key_map.F = {
    \ 'name': '+fold',
    \ 'O' : [':set foldlevel=20', 'open all'],
    \ 'C' : [':set foldlevel=0', 'close all'],
    \ 'c' : [':foldclose', 'close'],
    \ 'o' : [':foldopen', 'open'],
    \ '1' : [':set foldlevel=1', 'level1'],
    \ '2' : [':set foldlevel=2', 'level2'],
    \ '3' : [':set foldlevel=3', 'level3'],
    \ '4' : [':set foldlevel=4', 'level4'],
    \ '5' : [':set foldlevel=5', 'level5'],
    \ '6' : [':set foldlevel=6', 'level6']
    \ }

let g:which_key_map.t = {
      \ 'name' : '+telescope' ,
      \ '.' : [':lua require("plugins.telescope").search_dotfiles{}', 'config'],
      \ '?' : [':Telescope filetypes', 'filetypes'],
      \ 'b' : [':Telescope git_branches', 'git branches'],
      \ 'f' : [':Telescope find_files', 'files'],
      \ 'h' : [':Telescope command_history', 'history'],
      \ 'p' : [':Telescope media_files', 'media'],
      \ 'm' : [':Telescope marks', 'marks'],
      \ 'M' : [':Telescope man_pages', 'manuals'],
      \ 'o' : [':Telescope vim_options', 'options'],
      \ 't' : [':Telescope live_grep', 'text'],
      \ 'r' : [':Telescope registers', 'registers'],
      \ 'w' : [':Telescope file_browser', 'fuzzy find'],
      \ 'c' : [':Telescope colorscheme', 'colorschemes'],
      \ }

let g:which_key_map.S = {
      \ 'name' : '+session' ,
      \ 's' : [':SessionSave', 'save session'],
      \ 'l' : [':SessionLoad', 'load Session'],
      \ }

let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'b' : [':GitBlameToggle', 'blame'],
      \ 'B' : [':GBrowse', 'browse'],
      \ 'd' : [':Git diff', 'diff'],
      \ 'j' : [':NextHunk', 'next hunk'],
      \ 'k' : [':PrevHunk', 'prev hunk'],
      \ 'l' : [':Git log', 'log'],
      \ 'p' : [':PreviewHunk', 'preview hunk'],
      \ 'r' : [':ResetHunk', 'reset hunk'],
      \ 'R' : [':ResetBuffer', 'reset buffer'],
      \ 's' : [':StageHunk', 'stage hunk'],
      \ 'S' : [':Gstatus', 'status'],
      \ 'u' : [':UndoStageHunk', 'undo stage hunk'],
      \ }

command! -nargs=0 LspVirtualTextToggle lua require("lsp.virtual_text").toggle()
let g:which_key_map.l = {
      \ 'name' : '+lsp' ,
      \ 'a' : [':Lspsaga code_action', 'code action'],
      \ 'A' : [':Lspsaga range_code_action', 'selected action'],
      \ 'd' : [':Telescope lsp_document_diagnostics', 'doc diagnostics'],
      \ 'D' : [':Telescope lsp_workspace_diagnostics', 'workspace diagnostics'],
      \ 'f' : [':LspFormatting', 'format'],
      \ '?' : [':LspInfo', 'lsp info'],
      \ 'v' : [':LspVirtualTextToggle', 'toggle virtual text'],
      \ 'l' : [':Lspsaga lsp_finder', 'lsp finder'],
      \ 'L' : [':Lspsaga show_line_diagnostics', 'line diagnostics'],
      \ 'p' : [':Lspsaga preview_definition', 'preview definition'],
      \ 'q' : [':Telescope quickfix', 'quickfix'],
      \ 'r' : [':Lspsaga rename', 'rename'],
      \ 'T' : [':LspTypeDefinition', 'type defintion'],
      \ 'x' : [':cclose', 'close quickfix'],
      \ 's' : [':Telescope lsp_document_symbols', 'document symbols'],
      \ 'S' : [':Telescope lsp_workspace_symbols', 'workspace symbols'],
      \ }

let g:which_key_map.m = {
      \ 'name' : '+markdown' ,
      \ 'p' : [':MarkdownPreview', 'preview'],
      \ 's' : [':MarkdownPreviewStop', 'stop preview'],
      \ 't' : [':MarkdownPreviewToggle', 'toggle preview'],
      \ }


