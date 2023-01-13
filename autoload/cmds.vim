" Author: Violet
" Last Change: 23 February 2022

" search through a list of buffer numbers/names with *grep*
function! cmds#FilelistGrep(search, lst)
  call setqflist([])
  for l:n in a:lst
    silent! execute printf('silent grepadd! "%s" %s', escape(a:search, '"'),
     \ fnameescape(fnamemodify(bufname(l:n), ':p')))
  endfor
  bot cwindow
  redraw!
endfunction

" search through a list of buffer numbers/names with *vimgrep* (slow)
function! cmds#FilelistVimgrep(search)
  call setqflist([])
  for l:n in a:lst
    silent! execute printf('silent vimgrepadd! "%s" %s', escape(a:search, '"'),
     \ fnameescape(fnamemodify(bufname(l:n), ':p')))
  endfor
  bot cwindow
  redraw!
endfunction

" :argdo without mucking syntax or changing buffers
function! cmds#ArgDo(args) abort
  let l:bufnr = bufnr('')
  execute 'argdo silent set eventignore-=Syntax |' a:args
  execute 'silent buffer' l:bufnr
endfunction

" :bufdo without mucking syntax or changing buffers
function! cmds#BufDo(args) abort
  let l:bufnr = bufnr('')
  execute 'bufdo silent set eventignore-=Syntax |' a:args
  execute 'silent buffer ' l:bufnr
endfunction

" :windo without changing windows
function! cmds#WinDo(args) abort
  let l:winnr = winnr()
  execute 'windo silent set eventignore-=Syntax |' a:args
  execute 'silent' l:winnr 'wincmd w'
endfunction

" reload a vim file and attempt unlet the guard
function! cmds#SourceVimGuard()
  let l:guardName = ''
  let l:guardMatch = get(g:, 'guardMatch',
   \ '^\s*\%(else\)\?if\s\+exists\s*(\s*[''"]\%(g:\)\?\(\w\+\)[''"]\s*)\s*$')
  for l:line in getbufline(bufnr('%'), 1, get(g:, 'reload_max_lines', 10))
    if empty(l:guardName)
      if l:line !~# '\m'.l:guardMatch
        continue
      endif
      let l:guardName = substitute( l:line, l:guardMatch, '\1', '')
    elseif l:line =~# '\m^\s*finish\s*$'
      if ! empty(l:guardName)
        execute 'silent! unlet g:'.l:guardName
      endif
      execute 'source' fnameescape(expand('%:p'))
      return
    endif
  endfor
endfunction

function! cmds#Put(cmd, line, pos, new, mods)
  redir => out
  exec 'silent ' . a:cmd
  redir end
  if a:new
    execute a:mods.(a:mods?' ':'')'new +setl\ bt=nofile'
  endif
  if a:line < line('.')
    let a:pos[1] += len(split(out, "\n")) + 2
  endif
  silent execute (a:new?'':a:line) . 'put =out'
  call setpos('.', a:new ? [0,1,1,0] : a:pos)
endfunction

function! cmds#Make(args)
  if a:args !~ '^\s*$'
    let g:make_args = a:args
  endif
  execute 'silent make' get(g:, 'make_args', '')
  redraw!
  unsilent echo ':Make' get(g:, 'make_args', '')
endfunction

function! cmds#Lmake(args)
  if a:args !~ '^\s*$'
    let g:lmake_args = a:args
  endif
  execute 'silent lmake' get(g:, 'lmake_args', '')
  redraw!
  unsilent echo ':Lmake' get(g:, 'lmake_args', '')
endfunction

function! cmds#Bufcheck(_, n)
  return buflisted(a:n) && empty(getbufvar(a:n, '&buftype'))
endfunction

