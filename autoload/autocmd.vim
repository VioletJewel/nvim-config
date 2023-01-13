" Author: Violet
" Last Change: 07 March 2022

function! autocmd#HandleSwap(filename)
    let pid = string(swapinfo(v:swapname).pid)
    let ppid = '(pid: '.pid.')'
    let fname = '"'.fnameescape(expand('%')).'"'
    echohl WarningMsg
    redraw
    if getftime(v:swapname) < getftime(a:filename)
        " delete swap file if older than file itself; then edit
        let v:swapchoice = 'e'
        unsil echom 'Old swap deleted:' fname ppid
        call delete(v:swapname)
    else
        let haspgrep = executable('pgrep')
        if haspgrep && index(systemlist('pgrep -x '..(has('nvim') ? 'nvim' : 'vim')), pid) >= 0
            " file open in another vim; edit
            let v:swapchoice = 'e'
            unsil echom 'Already editing' fname ppid
        else
            let v:swapchoice = 'o'
            " open read-only:
            "   if haspgrep, almost definitely a crash
            "   else, either crash or file open but can't discover (with pgrep)
            let out = haspgrep ? 'Crash' : 'Swapfile'
            let note = '-> use :DiffOrig and :recover if needed'
            unsil echom  out 'detected' ppid 'for' fname note
        endif
    endif
    echohl NONE
endfunction

function! autocmd#updateLastChange() abort
  if !get(b:, 'last_change', get(g:, 'last_change', v:true))
    return
  endif
  let viewsav = winsaveview()
  let fmt = get(b:, 'last_datefmt', get(g:, 'last_datefmt', '%d %B %Y'))
  let date = strftime(fmt)
  let cms = map(split(&commentstring, '\s*%s\s*'), { _,c -> escape(c, '\/*+%(){}[]<>|^$~&@?=') })
  let r = printf('\v\c^\s*%%(%s)?\s*Last\s+Change:\s*\zs%(%s)@!%%(%%(\d{,4}|\a{3,9}|\d{2}|\d{4})%%(\s+|$)){,3}\ze\s*%%(%s)?$',
   \ get(cms, 0, ''), escape(date, '\/*+%(){}[]<>|^$~&@?='), get(cms, 1, ''))
  let ssav = @/
  let @/ = r
  execute 'keeppatterns keepjumps keepmarks %s/'..r..'/\=l:date/e'
  let @/ = ssav
  call winrestview(viewsav)
endfunction

