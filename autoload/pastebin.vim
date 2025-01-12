let s:regMap = {
      \  'char'   : [ 'v',      "'[", "']" ],
      \  'line'   : [ 'V',      "'[", "']" ],
      \  'v'      : [ 'v',      "'<", "'>" ],
      \  "\<C-v>" : [ "\<C-v>", "'<", "'>" ],
      \  'V'      : [ 'V',      "'<", "'>" ],
      \}

function pastebin#paste(type)
  let a = get(s:regMap, a:type, s:regMap.line)
  let lines = getregion(getpos(a[1]), getpos(a[2]), #{type: a[0]})->join("\n").."\n"
  let lines = system("curl -N -s -F'file=@-' https://0x0.st", lines)->substitute('\_s\+$', '', '')
  call setreg('+', lines)
  echo '@+ =' lines
endfunction
