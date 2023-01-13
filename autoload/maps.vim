" Author: Violet
" Last Change: 04 June 2022

" Quick: {{{1

function! maps#moveLine(down, count, visual)
  if a:visual
    let rng = "'<,'>"
    let bound = a:down ? "'>" : "'<"
  else
    let fc = foldclosed('.')
    if fc != -1
      let fce = foldclosedend('.')
      let rng = fc.','.fce
      let bound = a:down ? (foldclosed(fce+1) ? foldclosedend(fce+1)-1 : '+1') : '-1'
    else
      let rng = ''
      let bound = ''
    endif
  endif
  let cnt  = a:down ? v:count1 : v:count1 + 1
  exec printf("sil keepj %sm%s%s%d", rng, bound, a:down ? '+' : '-', cnt)
  call setpos('.', getpos("'["))
  let num = line("']") - line("'[") + 1
  " unsil echo 'moved' num 'line'.(num-1?'s':'') (a:down?'down':'up') cnt
  sil! call repeat#set(":\<c-u>sil! undoj|call maps#moveLine(".a:down.",".a:count.",".a:visual.")\<cr>")
  " if a:visual
  "     norm! gvo
  " endif
endfunction

function! maps#nextFile(forwards)
  let file = &ft is 'netrw' ? b:netrw_curdir : expand('%')
  if empty(file)
    let file = '.'
  endif
  let dotpre = expand('%:h') == '.'
  if dotpre
    let file = './'..file
  endif
  let files = filter(glob('%:h/*', 0, 1) + glob('%:h/.*', 0, 1), { _,f -> !isdirectory(f) && getftype(f) isnot 'link' })
  let lenfiles = len(files)
  if !len(files)
    echohl ErrorMsg
    unsil echo 'No files in directory'
    echohl NONE
    return
  endif
  let ind = (index(files, file) + (a:forwards ? 1 : -1) + lenfiles) % lenfiles
  exe 'edit' fnameescape(dotpre ? files[ind][2:] : files[ind])
endfunction

" Random: {{{1

function! maps#stargn(exact)
  if a:exact
    call setreg('/', '\<'..expand('<cword>')..'\>\C')
  else
    call setreg('/', expand('<cword>')..'\C')
  endif
  return ":let v:hlsearch = 1 | norm! gn\<cr>"
endfunction

function! maps#locToggle() abort
  let wnr = winnr('$')
  let wid = win_getid()
  belowright lopen
  if winnr('$') is wnr
    lclose
    call win_gotoid(wid)
  endif
endfunction

function! maps#qfToggle()
  let wnr = winnr('$')
  let wid = win_getid()
  belowright copen
  if winnr('$') is wnr
    cclose
    call win_gotoid(wid)
  endif
endfunction

" when cursor at EOL and <cr> and opening brace, add closing brace 2 lines down;
" map with inoremap <expr> <cr> maps#iCr()
function! maps#iCr()
  let l:col = col('.')
  let l:pre = pumvisible() ? "\<c-y>" : ''
  if l:col !=# col('$')
    return l:pre."\<cr>"
  endif
  let l:mps = map(split(&matchpairs, ','), "split(v:val, ':')")
  let l:i = -1
  let l:bn = bufnr('.')
  for l:mp in split(get(g:, 'crIgnores', ''), ',')
    let l:i = index(l:mps, split(l:mp, ':'))
    if l:i + 1
      call remove(l:mps, l:i)
    endif
  endfor
  for l:mp in split(getbufvar(l:bn, 'crIgnores', ''), ',')
    let l:i = index(l:mps, split(l:mp, ':'))
    if l:i + 1
      call remove(l:mps, l:i)
    endif
  endfor
  let l:mps +=
   \   map(split(get(g:, 'crMatchpairs', ''), ','), "split(v:val, ':')") +
   \   map(split(getbufvar(l:bn, 'crMatchpairs', ''), ','), "split(v:val, ':')")
  let l:i = index(map(copy(l:mps), 'v:val[0]'), getline('.')[l:col - 2])
  if l:i + 1
    " make sure that you have !^F in |cinkeys|;
    " the <c-f> is to not break folding with my autocmd's that save/restore
    " |'fdm'| (set to 'manual' in insert mode to preserve folding)
    let l:extra = ''
    if ! &cindent
      setl cin
      let l:extra = "\<c-r>=execute('setl nocin')\<cr>"
    endif
    return l:pre."\<cr>\<cr>".l:mps[l:i][1]."\<up>\<c-f>".l:extra
  else
    return l:pre."\<cr>"
  endif
endfunction

function! maps#pastebin(type)
  if a:type is# 'char'
    let l:regsave = getreg('"')
    normal! `[v`]y
    let l:text = split(getreg('"', "\n"))
    call setreg('"', l:regsave)
  elseif a:type is# 'line'
    let l:text = getline(line("'["), "']")
  elseif a:type is# 'v' || a:type is# "\<c-v>"
    let l:regsave = getreg('"')
    normal! gvy
    let l:text = split(@", "\n")
    call setreg('"', l:regsave)
  elseif a:type is# 'V'
    let l:text = getline(line("'<"), "'>")
  else
    let l:text = getline(line("'["), "']")
  endif
  let l:tmp = tempname()
  call writefile(l:text, l:tmp)
  " ix.io
  call setreg('+', systemlist('sh -c ''curl -NsF "text=<'.l:tmp.'" vpaste.net?ft='.&ft.'\&bg=dark''')[0])
  unsilent echon "\rDone: @+ = ".@+
endfunction

function! maps#visSearch()
  let savs = [@0, @"]
  norm! gvy
  call setreg('/', '\V'.escape(@", '\'))
  let [@0, @"] = savs
endfunction

function! maps#o_word(big)
  let ww = &whichwrap
  silent! set whichwrap+=h
  execute 'normal! v'..v:count1..'wW'[a:big]..'h'
  let &whichwrap = ww
endfunction

