" Author: Violet
" Last Change: 01 October 2020

if !has('mksession')
  function! mkview#should()
    return 0
  endfunction

  function! mkview#make()
  endfunction

  function! mkview#load()
  endfunction

  finish
endif

if !exists('g:nomkview_fts')
  " NOTE: let g:nomkview = 1 to disable mking views
  let nomkview_fts = ['gitcommit', 'lsbuffer']
endif

function! mkview#should()
  " only :mkview or :loadview if:
  "   - buffer is listed in :ls             - &buftype is empty
  "   - {b:,w:,g:}nomkview are 0 or unset   - &filetype is not in g:nomkview_fts
  if &buflisted && !empty(expand('%')) && empty(&bt) && !get(g:, 'nomkview', get(b:, 'nomkview',
  \ get(w:, 'nomkview', index(get(g:, 'nomkview_fts', []), &ft) isnot -1)))
    return 1
  endif
  return 0
endfunction

function! mkview#make()
  if mkview#should()
    let [&vop, vop] = ['cursor,folds', &vop]
    mkview!
    let &vop = vop
  endif
endfunction

function! mkview#load()
  if mkview#should()
    silent! loadview
  endif
endfunction

