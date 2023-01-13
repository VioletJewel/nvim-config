" Author: Violet
" Last Change: 08 January 2023

" Things I never type correctly...

abbrev unkown unknown

" pseudo-fix missing "v" prefixed commands
"   eg: :vsb -> vert sb

cabbrev <expr> vsb getcmdline() =~# '^vsb'   && getcmdtype() == ':' && getcmdpos() is 4 ? 'vert sb' : 'vsb'
cabbrev <expr> vh getcmdline() =~# '^vh'     && getcmdtype() == ':' && getcmdpos() is 3 ? 'vert h' : 'vh'
cabbrev <expr> vsn getcmdline() =~# '^vsn'   && getcmdtype() == ':' && getcmdpos() is 4 ? 'vert sn' : 'vsn'
cabbrev <expr> vspr getcmdline() =~# '^vspr' && getcmdtype() == ':' && getcmdpos() is 5 ? 'vert spr' : 'vspr'
cabbrev <expr> vsbn getcmdline() =~# '^vsbn' && getcmdtype() == ':' && getcmdpos() is 5 ? 'vert sbn' : 'vsbn'
cabbrev <expr> vsbp getcmdline() =~# '^vsbp' && getcmdtype() == ':' && getcmdpos() is 5 ? 'vert sbp' : 'vsbp'

cabbrev <expr> vsb# getcmdline() =~# '^vsb#'   && getcmdtype() == ':' && getcmdpos() is 5 ? 'vert sb#' : 'vsb#'
cabbrev <expr> vh# getcmdline() =~# '^vh#'     && getcmdtype() == ':' && getcmdpos() is 4 ? 'vert h#' : 'vh#'
cabbrev <expr> vsn# getcmdline() =~# '^vsn#'   && getcmdtype() == ':' && getcmdpos() is 5 ? 'vert sn#' : 'vsn#'
cabbrev <expr> vspr# getcmdline() =~# '^vspr#' && getcmdtype() == ':' && getcmdpos() is 6 ? 'vert spr#' : 'vspr#'
cabbrev <expr> vsbn# getcmdline() =~# '^vsbn#' && getcmdtype() == ':' && getcmdpos() is 6 ? 'vert sbn#' : 'vsbn#'
cabbrev <expr> vsbp# getcmdline() =~# '^vsbp#' && getcmdtype() == ':' && getcmdpos() is 6 ? 'vert sbp#' : 'vsbp#'

