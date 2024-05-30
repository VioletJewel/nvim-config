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

" text objects {{{1

" realign visual selection's current corner if a:other is false
" realign visual selection's other corner if a:other is true
function! maps#visualGoOther(other)
  execute "normal! \<c-bslash>\<c-n>"
  if a:other
    normal! gv
    execute 'normal! o'.virtcol('.').'|o'
  else
    normal! gvo
    execute 'normal! o'.virtcol('.').'|'
  endif
endfunction

" move current line to other corner's line if a:other is false
" move other corner's line to current line if a:other is true
"   NOTE: you can't do exe 'norm! gvo'.line('.').'G' in one step bc vim=silly
function! maps#visualGoLine(other)
  execute "normal! \<c-bslash>\<c-n>"
  if a:other
    normal! gv
    execute 'normal! o'.line('.').'Go'
  else
    normal! gvo
    execute 'normal! o'.line('.').'G'
  endif
endfunction

" regular expressions that match numbers (order matters .. keep '\d' last!)
" note: \+ will be appended to the end of each
let s:regNums = [ '0b[01]', '0x\x', '\d' ]

" select the next number on the line
" this can handle the following three formats (so long as maps#regNums is
" defined as it should be above this function):
"   1. binary  (eg: "0b1010", "0b0000", etc)
"   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
"   3. decimal (eg: "0", "0000", "10", "01", etc)
" NOTE: if there is no number on the rest of the line starting at the
"       current cursor position, then visual selection mode is ended (if
"       called via an omap) or nothing is selected (if called via xmap)
function! maps#inNumber()

  " need magic for this to work properly
  let l:magic = &magic
  set magic

  execute "normal! \<c-bslash>\<c-n>"

  let l:lineNr = line('.')

  " create regex pattern matching any binary, hex, decimal number
  let l:pat = join(s:regNums, '\+\|') . '\+'

  " move cursor to end of number
  if (!search(l:pat, 'ce', l:lineNr))
    " if it fails, there was not match on the line, so return prematurely
    return
  endif

  " start visually selecting from end of number
  normal! v

  " move cursor to beginning of number
  call search(l:pat, 'cb', l:lineNr)

  " restore magic
  let &magic = l:magic
endfunction

" select the next number on the line and any surrounding white-space;
" this can handle the following three formats (so long as maps#regNums is
" defined as it should be above these functions):
"   1. binary  (eg: "0b1010", "0b0000", etc)
"   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
"   3. decimal (eg: "0", "0000", "10", "01", etc)
" NOTE: if there is no number on the rest of the line starting at the
"       current cursor position, then visual selection mode is ended (if
"       called via an omap) or nothing is selected (if called via xmap);
"       this is true even if on the space following a number
function! maps#aroundNumber()

  " need magic for this to work properly
  let l:magic = &magic
  set magic

  execute "normal! \<c-bslash>\<c-n>"

  let l:lineNr = line('.')

  " create regex pattern matching any binary, hex, decimal number
  let l:pat = join(maps#regNums, '\+\|') . '\+'

  " move cursor to end of number
  if (!search(l:pat, 'ce', l:lineNr))
    " if it fails, there was not match on the line, so return prematurely
    return
  endif

  " move cursor to end of any trailing white-space (if there is any)
  call search('\%'.(virtcol('.')+1).'v\s*', 'ce', l:lineNr)

  " start visually selecting from end of number + potential trailing whitspace
  normal! v

  " move cursor to beginning of number
  call search(l:pat, 'cb', l:lineNr)

  " move cursor to beginning of any white-space preceding number (if any)
  call search('\s*\%'.virtcol('.').'v', 'b', l:lineNr)

  " restore magic
  let &magic = l:magic
endfunction

" select all text in current indentation level excluding any empty lines
" that precede or follow the current indentationt level;
"
" the current implementation is pretty fast, even for many lines since it
" uses "search()" with "\%v" to find the unindented levels
"
" NOTE: if the current level of indentation is 1 (ie in virtual column 1),
"       then the entire buffer will be selected
"
" WARNING: python devs have been known to become addicted to this
function! maps#inIndentation()

  " magic is needed for this
  let l:magic = &magic
  set magic

  execute "normal! \<c-bslash>\<c-n>"

  " move to beginning of line and get virtcol (current indentation level)
  " BRAM: there is no searchpairvirtpos() ;)
  normal! ^
  let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

  " find first match (backwards & don't wrap or move cursor)
  let l:start = search(l:pat, 'bWn') + 1

  " next, find first match (forwards & don't wrap or move cursor)
  let l:end = search(l:pat, 'Wn')

  if (l:end !=# 0)
    " if search succeeded, it went too far, so subtract 1
    let l:end -= 1
  endif

  " go to start (this includes empty lines) and--importantly--column 0
  execute 'normal! '.l:start.'G0'

  " skip empty lines (unless already on one .. need to be in column 0)
  call search('^[^\n\r]', 'Wc')

  " go to end (this includes empty lines)
  execute 'normal! Vo'.l:end.'G'

  " skip backwards to last selected non-empty line
  call search('^[^\n\r]', 'bWc')

  " go to end-of-line 'cause why not
  normal! $o

  " restore magic
  let &magic = l:magic
endfunction

" select all text in the current indentation level including any emtpy
" lines that precede or follow the current indentation level;
"
" the current implementation is pretty fast, even for many lines since it
" uses "search()" with "\%v" to find the unindented levels
"
" NOTE: if the current level of indentation is 1 (ie in virtual column 1),
"       then the entire buffer will be selected
"
" WARNING: python devs have been known to become addicted to this
function! maps#aroundIndentation()

  " magic is needed for this (/\v doesn't seem work)
  let l:magic = &magic
  set magic

  execute "normal! \<c-bslash>\<c-n>"

  " move to beginning of line and get virtcol (current indentation level)
  " BRAM: there is no searchpairvirtpos() ;)
  normal! ^
  let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

  " find first match (backwards & don't wrap or move cursor)
  let l:start = search(l:pat, 'bWn') + 1

  " NOTE: if l:start is 0, then search() failed; otherwise search() succeeded
  "       and l:start does not equal line('.')
  " FORMER: l:start is 0; so, if we add 1 to l:start, then it will match
  "         everything from beginning of the buffer (if you don't like
  "         this, then you can modify the code) since this will be the
  "         equivalent of "norm! 1G" below
  " LATTER: l:start is not 0 but is also not equal to line('.'); therefore,
  "         we want to add one to l:start since it will always match one
  "         line too high if search() succeeds

  " next, find first match (forwards & don't wrap or move cursor)
  let l:end = search(l:pat, 'Wn')

  " NOTE: if l:end is 0, then search() failed; otherwise, if l:end is not
  "       equal to line('.'), then the search succeeded.
  " FORMER: l:end is 0; we want this to match until the end-of-buffer if it
  "         fails to find a match for same reason as mentioned above;
  "         again, modify code if you do not like this); therefore, keep
  "         0--see "NOTE:" below inside the if block comment
  " LATTER: l:end is not 0, so the search() must have succeeded, which means
  "         that l:end will match a different line than line('.')

  if (l:end !=# 0)
    " if l:end is 0, then the search() failed; if we subtract 1, then it
    " will effectively do "norm! -1G" which is definitely not what is
    " desired for probably every circumstance; therefore, only subtract one
    " if the search() succeeded since this means that it will match at least
    " one line too far down
    " NOTE: exec "norm! 0G" still goes to end-of-buffer just like "norm! G",
    "       so it's ok if l:end is kept as 0. As mentioned above, this means
    "       that it will match until end of buffer, but that is what I want
    "       anyway (change code if you don't want)
    let l:end -= 1
  endif

  " finally, select from l:start to l:end
  execute 'normal! '.l:start.'G0V'.l:end.'G$o'

  " restore magic
  let &magic = l:magic
endfunction

