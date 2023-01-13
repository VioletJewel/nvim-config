" Author: Violet
" Last Change: 04 June 2022

let s:atts = ['bold', 'italic', 'reverse', 'inverse', 'standout', 'underline', 'undercurl', 'strikethrough']
let s:colors = ['ctermfg', 'ctermbg', 'guifg', 'guibg']

" echo hl chain (and resolutions) synstack with color
" also, print the attributes for final attribute
function! synstack#echo()
  let first = 2
  unsilent echon "\r"
  for id in reverse(synstack(line('.'), col('.')))
    if first > 1
      let first = 1
    else
      unsilent echon ' <- '
    endif
    let syn = synIDattr(id, 'name')
    let transId = synIDtrans(id)
    execute 'echohl' syn
    unsilent echon syn
    if id !=# transId
      unsilent echon ' [' synIDattr(transId, 'name') ']'
    endif
    if first
      let catts = join(filter(map(s:atts[:], { _,att -> synIDattr(transId, att, 'cterm') ? att : '' }), { _,s -> !empty(s) }), ',')
      let gatts = join(filter(map(s:atts[:], { _,att -> synIDattr(transId, att, 'gui') ? att : '' }), { _,s -> !empty(s) }), ',')
      let out = ['cterm='..catts, 'gui='..gatts]
      call extend(out, map(s:colors[:], { _,col -> col..'='..synIDattr(transId, col[-2:], col[:-3]) }))
      " unsilent echon transId out filter(out, { _,att -> att !~ '=$' })
      unsilent echon ' <'..join(filter(out, { _,att -> att !~ '=$' }))..'> '
      let first = 0
    endif
    echohl NONE
  endfor
  echohl NONE
  if first
    unsilent echon 'No syntax groups under cursor'
  endif
endfunction

function! synstack#vExprPrint()
  let m = mode()
  let l = abs(line('v') - line('.')) + 1
  unsil echon m ': '
  echohl Number
  unsil echon l
  echohl NONE
  if m is "\<c-v>"
    echon 'x'
    echohl Number
    echon abs(virtcol('v') - virtcol('.')) + 1
    echohl NONE
  endif
  let wc = wordcount()
  echohl SpecialKey
  echon ' -> '
  echohl Number
  unsil echon wc.visual_chars
  echohl NONE
  echon ' chars'
  echohl SpecialKey
  echon ' -> '
  echohl Number
  unsil echon wc.visual_bytes
  echohl NONE
  echon ' bytes'
  echohl SpecialKey
  echon ' -> '
  echohl Number
  unsil echon wc.visual_words
  echohl NONE
  echon ' words'
  return ''
endfunction

