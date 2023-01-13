" Author: Violet
" Last Change: 08 January 2023

nnoremap <buffer> <localleader>S :execute 'Vimix!' expand('%:h')..'/colors/'<cr>:update<bar>exe 'colo' expand('%:t:r')<cr>
let b:undo_ftplugin = 'nunmap <buffer> <localleader>S'

