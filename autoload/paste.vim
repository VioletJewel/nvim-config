" Author: Violet
" Last Change: 18 March 2022

function! s:ix(f) " sets language based on file extension
  return printf("sh -c 'curl -sF \"f:1=@%s\" http://ix.io'", escape(a:f, "'"))
endfunction

function! s:sprunge(f)
  return printf("sh -c 'curl -sF \"sprunge=<%s\" http://sprunge.us'", escape(a:f, "'"))
endfunction

function! s:vpaste(f)
  return printf("sh -c 'curl -sF \"text=<%s\" http://vpaste.net?ft=%s&bg=dark'", escape(a:f, "'"), &ft)
endfunction

function! s:clbin(f)
  return printf("sh -c 'curl -sF \"clbin=<%s\" https://clbin.com'", escape(a:f, "'"))
endfunction

function! s:envs(f)
  return printf("sh -c 'curl -sF \"file=@%s\" https://envs.sh'", escape(a:f, "'"))
endfunction

function! s:termbin(f) " slow
  return printf("sh -c 'cat \"%s\" | nc termbin.com 9999'", escape(a:f, '"'))
endfunction


function s:nomod(out)
  let out = filter(a:out, "v:val !~ '^\\_s*$'")
  let len = len(a:out)
  if len is 0
    echohl ErrorMsg
    unsilent echom 'Pastebin Error: No Output'
    echohl Error
    return 'Pastbin Error; see :messages for more info'
  elseif len > 1 || a:out[0] !~# '^\s*http'
    echohl ErrorMsg
    unsilent echom 'Pastebin Error:'
    for line in a:out
      unsilent echom '|' line
    endfor
    echohl Error
    return 'Pastbin Error; see :messages for more info'
  endif
  let url = trim(a:out[0])
  return url
endfunction

function! s:ixmod(out)
  let out = s:nomod(a:out)
  if out =~ '^http'
    let out ..= '/'..&ft
  endif
  return out
endfunction

function! s:sprungemod(out)
  let out = s:nomod(a:out)
  if out =~ '^http'
    let out ..= '?'..&ft
  endif
  return out
endfunction


let s:bins = #{
 \ ix:       [ funcref('s:ix'),       funcref('s:ixmod')      ],
 \ sprunge:  [ funcref('s:sprunge'),  funcref('s:sprungemod') ],
 \ vpaste:   [ funcref('s:vpaste'),   funcref('s:nomod')      ],
 \ clbin:    [ funcref('s:clbin'),    funcref('s:nomod')      ],
 \ envs:     [ funcref('s:envs'),     funcref('s:nomod')      ],
 \ termbin:  [ funcref('s:termbin'),  funcref('s:nomod')      ],
 \}

let s:defaultname = 'ix'
function! s:name(name)
  let name =  a:name ? a:name : get(b:, 'pastebin', get(g:, 'pastebin'))
  return has_key(s:bins, name) ? name : s:defaultname
endfunction

function! paste#complete(arglead, cmdline, curpos)
  unsil echom a:arglead
  return filter(keys(s:bins), { _,v -> v =~# '\V\^'..escape(a:arglead, '\') })
endfunction

function! paste#bin(type, ...) abort
  if a:type is# 'char'
    let regsave = getreg('"')
    normal! `[v`]y
    let text = split(getreg('"', "\n"))
    call setreg('"', regsave)
  elseif a:type is# 'line'
    let text = getline(line("'["), "']")
  elseif a:type is# 'v' || a:type is# "\<c-v>"
    let regsave = getreg('"')
    normal! gvy
    let text = split(@", "\n")
    call setreg('"', regsave)
  elseif a:type is# 'V'
    let text = getline(line("'<"), "'>")
  elseif a:type is# 'command'
    let text = getline(a:1, a:2)
  else
    let text = getline(line("'["), "']")
  endif
  let tmp = tempname()..'.'..expand('%:e')
  call writefile(text, tmp)
  let bin = s:bins[s:name(a:0 > 2 ? a:3 : '')]
  let exec = bin[0](escape(tmp, '"'))
  unsilent echom '!'..exec
  let out = bin[1](systemlist(exec))
  if out =~ '^http'
    if get(b:, 'pasteopen', get(g:, 'pasteopen', 1))
      execute 'silent !xdg-open' fnameescape(out)
    endif
    redraw
    if has('clipboard')
      call setreg('+', out)
      unsilent echon '@+ Clipboard ->' string(out)
    else
      unsilent echon 'no clipboard -> @+ not set'
    endif
  else
    unsilent echon "\n" out
  endif
  echohl NONE
  call delete(tmp)
endfunction

