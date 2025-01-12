let s:regMap = {
      \  'char'   : [ "'[", "']" ],
      \  'line'   : [ "'[", "']" ],
      \  'v'      : [ "'<", "'>" ],
      \  "\<C-v>" : [ "'<", "'>" ],
      \  'V'      : [ "'<", "'>" ],
      \}

function luafold#createFold(type)
  let a = get(s:regMap, a:type, s:regMap.line)
  " echom 'regMap' a line(a[0]) line(a[1])
  execute 'keeppatterns' line(a[1]) 's/$/--</'
  execute 'keeppatterns' line(a[0]) 's/$/-->/'
endfunction
