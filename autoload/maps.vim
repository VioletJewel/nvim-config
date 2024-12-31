" Author: Violet
" Last Change: 04 June 2022

" moveLine {{{1

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
  " unsil echo 'moved' num 'line'..(num-1?'s':'') (a:down?'down':'up') cnt
  sil! call repeat#set(":\<c-u>sil! undoj|call maps#moveLine("..a:down..","..a:count..","..a:visual..")\<cr>")
  " if a:visual
  "     norm! gvo
  " endif
endfunction

" nextFile {{{1

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

