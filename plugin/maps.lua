local function fk(keys, mode) return vim.api.nvim_feedkeys(keys, mode, false) end
local function ek(keys) return vim.api.nvim_replace_termcodes(keys, true, true, true) end
local s = function(modes) return vim.split(modes, '') end
local map = vim.keymap.set

-- leader = <Nop>

map('n', '<Leader>', '', {
  desc = 'fix leader side effects'
})

-- saving

map(s 'nxic', '<M-w>', '<Cmd>silent update<CR>', {
  desc = 'update file quickly'
})

map(s 'nxic', '<M-W>', '<Cmd>silent noautocmd update<CR>', {
  desc = 'update file quickly (noautocmd)'
})

map(s 'nxic', '<M-e>', '<Cmd>silent wall<CR>', {
  desc = 'write all files quickly'
})

map(s 'nxic', '<M-E>', '<Cmd>silent noautocmd wall', {
  desc = 'write all files quickly (noautocmd)'
})

-- quit

map('n', '<LocalLeader>q', '<Cmd>qall<CR>', {
  desc = 'quit quickly'
})

-- source

map('n', '<LocalLeader>s', '<Cmd>silent update | source %<CR>', {
  desc = 'update and source current file'
})

-- C-l overload

map('n', "<C-l>", "<Cmd>nohlsearch | diffupdate | redraw! | echon ''<CR>", {
  desc = 'overload <C-l>'
})

-- C-p

map(s 'nx', '<C-p>', function()
  fk(ek ':<Up>', 'tx!')
end, {
  desc = 'get to previous command quickly'
})

-- zO

map('n', 'zO', "foldclosed('.') == -1 ? 'zczO' : 'zO'", {
  expr = true,
  silent = true,
  desc = 'same as zO but if fold already open, close first'
})

-- ix.io paste

map('n', '<LocalLeader>B', ':set opfunc=maps#pastebin<CR>g@', {
  silent = true,
  desc = 'ix.io pastebin'
})

map('n', '<LocalLeader>BB', 'V<space>B', {
  remap = true,
  silent = true,
  desc = 'Pastebin line'
})

map('x', '<LocalLeader>B', ':<C-u>call maps#pastebin(visualmode())<CR>', {
  silent = true,
  desc = 'Pastebin visual selection'
})

-- loclist jump

map('n', "[w", ":<C-u>execute v:count..'lprevious'<CR>", {
  silent = true,
  desc = ':<count>lprevious'
})

map('n', "]w", ":<C-u>execute v:count..'lnext'<CR>", {
  silent = true,
  desc = ':<count>lnext'
})

-- quickfix jump

map('n', "[q", ":<C-u>execute v:count..'cprevious'<CR>", {
  silent = true,
  desc = '<count>cprevious'
})

map('n', "]q", ":<C-u>execute v:count..'cnext'<CR>", {
  silent = true,
  desc = '<count>cnext'
})

-- line move

map('n', '[e', ':<C-u>call maps#moveLine(0, v:count, 0)<CR>', {
  silent = true,
  desc = 'move line up'
})

map('x', '[e', ':<C-u>call maps#moveLine(0, v:count, 1)<CR>', {
  silent = true,
  desc = 'move selection up'
})

map('n', ']e', ':<C-u>call maps#moveLine(1, v:count, 0)<CR>', {
  silent = true,
  desc = 'move line down'
})

map('x', ']e', ':<C-u>call maps#moveLine(1, v:count, 1)<CR>', {
  silent = true,
  desc = 'move selection down'
})

-- git jump

local gitMarkReg = [[^\%(<<<<<<<\|=======\|>>>>>>>\)]]

map(s 'nx', '[g', function()
  for _ = 1, vim.v.count1 do
    vim.fn.search(gitMarkReg, 'wb')
  end
end, {
  desc = 'jump to previous git marker',
})

map('o', '[g', ":<C-u>exe 'norm V'..v:count..'[g'<CR>", {
  desc = '<count>]g operator'
})

map(s 'nx', ']g', function()
  for _ = 1, vim.v.count1 do
    vim.fn.search(gitMarkReg, 'w')
  end
end, {
  desc = 'jump to next <count>th git marker',
})

map('o', ']g', ":<C-u>exe 'norm V'..v:count..']g'<CR>", {
  desc = '<count>]g operator'
})

map(s 'nxo', '[G', function()
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.fn.search(gitMarkReg, 'wc')
end, {
  desc = 'jump to first git marker'
})

map(s 'nxo', ']G', function()
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  vim.fn.search(gitMarkReg, 'wbc')
end, {
  desc = 'jump to last git marker'
})

-- buffer jump

map('n', '[b', ":<C-u>execute v:count..'bprevious'<CR>", {
  silent = true,
  desc = ':<count>bprevious shortcut'
})

map('n', ']b', ":<C-u>execute v:count..'bnext'<CR>", {
  silent = true,
  desc = ':<count>bnext shortcut'
})

map('n', '[B', '<Cmd>bfirst<CR>', {
  desc = ':bfirst shortcut'
})

map('n', ']B', '<Cmd>blast<CR>', {
  desc = ':blast shortcut'
})

-- arg jump

map('n', "[a", ":<C-u>execute v:count..'previous'<CR>", {
  silent = true,
  desc = ':<count>previous shortcut'
})

map('n', "]a", ":<C-u>execute v:count..'next'<cr>", {
  silent = true,
  desc = ':<count>next shortcut'
})

map('n', '[A', '<Cmd>first<CR>', {
  desc = ':first shortcut'
})

map('n', ']A', '<Cmd>last<CR>', {
  desc = ':last shortcut'
})

-- file jump

map('n', ']f', ':call maps#nextFile(1)<CR>', {
  silent = true,
  desc = 'edit next file in directory'
})

map('n', '[f', ':call maps#nextFile(0)<CR>', {
  silent = true,
  desc = 'edit previous file in directory'
})

-- fzf

map('n', '<Leader>f', function()
  require 'fzf-lua'.files()
end, {
  desc = 'browse ./**'
})

map('n', '<LocalLeader>c', function()
  require 'fzf-lua'.files { cwd = vim.fn.stdpath 'config' }
end, {
  desc = 'edit files in config'
})

-- spell

map('n', '<M-s>', '[s1z=``:sil! call repeat#set("\\<M-s>")<CR>', {
  silent = true,
  desc = 'fix previous spell error'
})

vim.keymap.set('i', '<M-s>', function()
  local ecol = vim.fn.col '$'
  local lin, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col + 1
  local exp = ecol == col and 'A' or string.format("gi<C-r>=[''][setcursorcharpos(%d,%d+col('$'))]<CR>", lin, col - ecol)
  return '<Esc>[s1z=``' .. exp
end, {
  silent = true,
  expr = true,
  desc = 'fix previous spell error in insert mode'
})

map('n', '<M-S>', [[[SzG``:sil! call repeat#set("\<C-s>gh")<CR>]], {
  silent = true,
  desc = 'spell good internal'
})

vim.keymap.set('i', '<M-S>', function()
  local ecol = vim.fn.col'$'
  local lin, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col + 1
  local exp = ecol == col and 'A' or string.format("gi<C-r>=[''][setcursorcharpos(%d,%d+col('$'))]<CR>", lin, col - ecol)
  return '<Esc>[szG``' .. exp
end, {
  silent = true,
  expr = true,
  desc = 'fix previous spell error in insert mode'
})

-- searching

map('n', '*', [[<Cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<CR>]], {
    desc = "* but respect capitalization; don't move cursor"
  })

map('n', '#', [[<Cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<bar>call search('', 'bc')<CR>]], {
    desc = "# but respect capitalization; move cursor to beg of word"
  })

map('n', 'g*', [[<Cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<CR>]], {
  desc = "g* without \\< and \\>"
})

map('n', 'g#', [[<Cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<bar>call search('', 'bc')<CR>]], {
  desc = "g# without \\< and \\>"
})

-- eg c*ReplacementText<Esc>.... (dot repeat)

map('o', '*', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand'<cword>' .. '\\>\\C')
  vim.v.hlsearch = true
  vim.v.searchforward = true
  return "gn"
end, {
  silent = true,
  expr = true,
  desc = 'faster *N{op}gn'
})

map('o', '#', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand'<cword>' .. '\\>\\C')
  vim.v.hlsearch = true
  vim.v.searchforward = false
  return "gN"
end, {
  silent = true,
  expr = true,
  desc = 'faster #N{op}gn'
})


map('o', 'g*', function()
  vim.fn.setreg('/', vim.fn.expand'<cword>')
  vim.v.hlsearch = true
  vim.v.searchforward = true
end, {
  silent = true,
  expr = true,
  desc = 'faster g*N{op}gn'
})

map('o', 'g#', function()
  vim.fn.setreg('/', vim.fn.expand'<cword>')
  vim.v.hlsearch = true
  vim.v.searchforward = false
end, {
  silent = true,
  expr = true,
  desc = 'faster g#N{op}gn'
})

map(s 'nxo', 'n', function()
  return vim.v.searchforward ~= 0 and 'n' or 'N'
end, {
  expr = true,
  desc = 'always search forwards'
})

map(s 'nxo', 'N', function()
  return vim.v.searchforward ~= 0 and 'N' or 'n'
end, {
  expr = true,
  desc = 'always search backwards'
})

-- command line

map('c', '<M-h>', '<left>', {
  desc = 'go left in cmdline'
})

map('c', '<M-l>', '<right>', {
  desc = 'go right in cmdline'
})

map('c', '<M-k>', '<up>', {
  desc = 'go up in cmdline'
})

map('c', '<M-j>', '<down>', {
  desc = 'go down in cmdline'
})

map('c', '<M-b>', '<C-left>', {
  desc = 'go a word left in cmdline'
})

map('c', '<M-f>', '<C-right>', {
  desc = 'go a word right in cmdline'
})

map('c', '<M-a>', '<C-b>', {
  desc = 'go to beginning of cmdline'
})

map('c', '<M-e>', '<C-e>', {
  desc = 'go to end of cmdline'
})

-- simple text objects

map('x', 'il', '<Esc>g_v^', {
  desc = 'in-line text object'
})

map('o', 'il', '<Cmd>norm!g_v^<Cr>', {
  desc = 'in-line text object'
})

map('x', 'al', '<Esc>$v0', {
  desc = 'around-line text object'
})

map('o', 'al', '<Cmd>norm!$v0<Cr>', {
  desc = 'around-line text object'
})

map('x', 'id', '<Esc>G$Vgg0', {
  desc = 'in-document text object'
})

map('o', 'id', '<Cmd>norm!G$Vgg0<Cr>', {
  desc = 'in-document text object'
})

-- visual corner movement

map('x', 'go', function()
  fk(ek '<C-Bslash><C-n>', 'nx')
  fk('gvo', 'nx')
  fk('o' .. vim.fn.col '.' .. '|', 'nx')
end, {
  desc = "Go to Other - realign visual[block]'s current corner to other corner's column"
})

map('x', 'gO', function()
  fk('o' .. vim.fn.virtcol '.' .. '|o', 'nx')
end, {
  desc = "Grab Other corner - realign visual[block]'s other corner to current corner's column"
})

map('x', 'gl', function()
  fk(ek '<C-Bslash><C-n>', 'nx')
  fk('gvo', 'nx')
  fk('o' .. vim.fn.line '.' .. 'G', 'nx')
end, {
  desc = "Go to other Line - realign visual's current corner to other corner's line"
})

map('x', 'gL', function()
  fk('o' .. vim.fn.line '.' .. 'Go', 'nx')
end, {
  desc = "Grab other Line - realign visual's other corner to current corner's line"
})

-- number text objects

map(s 'xo', 'in', function()
  fk(ek '<C-Bslash><C-n>', 'nx')
  local lineNr = vim.fn.line '.'
  if vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'ce', lineNr) == 0 then return end
  fk('v', 'nx')
  vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'cb', lineNr)
end, {
  desc = 'In Number text object'
})

map(s 'xo', 'an', function()
  fk(ek '<C-Bslash><C-n>', 'nx')
  local lineNr = vim.fn.line '.'
  if vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'ce', lineNr) == 0 then return end
  vim.fn.search([[\%]] .. (vim.fn.virtcol '.' + 1) .. [[v\s*]], 'ce', lineNr)
  fk('v', 'nx')
  vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'cb', lineNr)
  vim.fn.search([[\s*\%]] .. vim.fn.virtcol '.' .. 'v', 'b', lineNr)
end, {
  desc = 'Around Number text object'
})

-- indentation text objects

map(s 'xo', 'ii', function()
  fk(ek '<C-Bslash><C-n>^', 'nx')
  local vCol = vim.fn.virtcol(string.find(vim.fn.getline '.', '^%s*$') and '$' or '.')
  local pat = [[^\(\s*\%]] .. vCol .. [[v\|^$\)\@!]]
  local pstart = vim.fn.search(pat, 'bWn') + 1
  local pend = vim.fn.search(pat, 'Wn')
  if pend ~= 0 then
    pend = pend - 1
  end
  vim.api.nvim_win_set_cursor(0, { pstart, 0 })
  vim.fn.search('^[^\\n\\r]', 'Wc')
  fk('Vo' .. pend .. 'G', 'nx')
  vim.fn.search('^[^\\n\\r]', 'bWc')
  fk('$o', 'nx')
end, {
  desc = 'In Indendation text object'
})

map(s 'xo', 'ai', function()
  fk(ek '<C-Bslash><C-n>^', 'nx')
  local vCol = vim.fn.virtcol(string.find(vim.fn.getline '.', '^%s*$') and '$' or '.')
  local pat = [[^\(\s*\%]] .. vCol .. [[v\|^$\)\@!]]
  print('pat', pat)
  local pstart = vim.fn.search(pat, 'bWn') + 1
  local pend = vim.fn.search(pat, 'Wn')
  if pend ~= 0 then
    pend = pend - 1
  end
  vim.api.nvim_win_set_cursor(0, { pstart, 0 })
  fk('V' .. pend .. 'G$o', 'nx')
end, {
  desc = 'Around Indentation text object'
})

-- cmdline abbreviations: eg, :vhelp => :vert help

local function vca(ab)
  map('ca', 'v' .. ab,
    string.format("getcmdline() == 'v%s' && getcmdtype() == ':' && getcmdpos() is %d ? 'vert %s' : 'v%s'", ab, #ab + 2,
      ab, ab), {
    expr = true,
    desc = ':vert ' .. ab .. ' abbrev hack (beg. of line only)'
  })
end

vim.iter(vim.gsplit(
  'al:l ba:ll diffs:plit dsp:lit h:elp isp:lit sN:ext sa:rgument sal:l sbN:ext sb:uffer sba:ll sbf:irst sbl:ast sbm:odified sbn:ext sbp:revious sbr:ewind sf:ind sfi sfi:rst sla:st sn:xt splitfind spr:evious sre:wind sta:g stj:ump sts:elect sv:iew',
  '%s'))
    :each(function(w)
      local ab, r = w:match '^(%S+):(%S-)$'
      if ab == nil then ab = w end
      vca(ab)
      if r ~= nil then vca(ab .. r) end
    end)

-- abbreviations for typos

map('ia', 'unkown', 'unknown', {
  desc = 'unkown => unknown abbrev'
})
