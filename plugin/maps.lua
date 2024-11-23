-- leader fix

vim.api.nvim_set_keymap('n', '<Leader>', '', {
  noremap = true,
  desc = 'map <Leader> to <Nop> to fix side effects'
})

-- save

vim.keymap.set({ 'n', 'x', 'i', 'c' }, '<M-w>', '<Cmd>silent update<Bar>redrawstatus!<CR>', {
  desc = 'update current file quickly'
})

vim.keymap.set({ 'n', 'x', 'i', 'c' }, '<M-W>', '<Cmd>silent noautocmd update<CR>', {
  desc = 'update current file quickly without triggering autocmds'
})

vim.keymap.set({ 'n', 'x', 'i', 'c' }, '<M-e>', '<Cmd>silent wall<CR>', {
  desc = 'write all files quickly'
})

vim.keymap.set({ 'n', 'x', 'i', 'c' }, '<M-E>', '<Cmd>silent noautocmd wall', {
  desc = 'write all files quickly without triggering noautocmds'
})

-- quit

vim.api.nvim_set_keymap('n', '<LocalLeader>q', '<Cmd>qall<CR>', {
  noremap = true,
  desc = 'quit quickly if no unsaved files'
})

-- source

vim.api.nvim_set_keymap('n', '<LocalLeader>s', '<Cmd>source %<CR>', {
  noremap = true,
  desc = 'source current file'
})

-- overload <C-l>

vim.api.nvim_set_keymap('n', "<C-l>", "<Cmd>nohlsearch | diffupdate | redraw! | echon ''<CR>", {
  noremap = true,
  desc = '<C-l> clears search hls, updates diffs, and redraws'
})

-- previous command

vim.api.nvim_set_keymap('', '<C-p>', '', {
  noremap = true,
  callback = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':<Up>', true, true, true), 'tx!', false)
  end,
  desc = 'open command-line and go <Up> to last command' -- this works in visual mode, too
})

-- recursive zO on open fold

vim.api.nvim_set_keymap('n', 'zO', "foldclosed('.') == -1 ? 'zczO' : 'zO'", {
  noremap = true,
  expr = true,
  silent = true,
  desc = 'like zO but close an open fold first to trigger recursive gO'
})

-- ix.io pastebin

vim.api.nvim_set_keymap('n', '<LocalLeader>B', ':set opfunc=maps#pastebin<CR>g@', {
  noremap = true,
  silent = true,
  desc = 'paste next text object to ix.io'
})

vim.api.nvim_set_keymap('n', '<LocalLeader>BB', 'V<space>B', {
  noremap = false,
  silent = true,
  desc = 'paste current line to ix.io'
})

vim.api.nvim_set_keymap('x', '<LocalLeader>B', ':<C-u>call maps#pastebin(visualmode())<CR>', {
  noremap = true,
  silent = true,
  desc = 'paste visual selection to ix.io'
})

-- loclist jump

vim.api.nvim_set_keymap('n', "[w", ":<C-u>execute v:count..'lprevious'<CR>", {
  noremap = true,
  silent = true,
  desc = 'goto [count]th previous loclist error'
})

vim.api.nvim_set_keymap('n', "]w", ":<C-u>execute v:count..'lnext'<CR>", {
  noremap = true,
  silent = true,
  desc = 'goto [count]th next loclist error'
})

-- quickfix jump

vim.api.nvim_set_keymap('n', "[q", ":<C-u>execute v:count..'cprevious'<CR>", {
  noremap = true,
  silent = true,
  desc = '<count>cprevious'
})

vim.api.nvim_set_keymap('n', "]q", ":<C-u>execute v:count..'cnext'<CR>", {
  noremap = true,
  silent = true,
  desc = '<count>cnext'
})

-- line move

vim.api.nvim_set_keymap('n', '[e', ':<C-u>call maps#moveLine(0, v:count, 0)<CR>', {
  noremap = true,
  silent = true,
  desc = 'move current line up [count]th lines'
})

vim.api.nvim_set_keymap('x', '[e', ':<C-u>call maps#moveLine(0, v:count, 1)<CR>', {
  noremap = true,
  silent = true,
  desc = 'move selection up [count]th lines'
})

vim.api.nvim_set_keymap('n', ']e', ':<C-u>call maps#moveLine(1, v:count, 0)<CR>', {
  noremap = true,
  silent = true,
  desc = 'move current line down [count]th lines'
})

vim.api.nvim_set_keymap('x', ']e', ':<C-u>call maps#moveLine(1, v:count, 1)<CR>', {
  noremap = true,
  silent = true,
  desc = 'move selection down [count]th lines'
})

-- git jump

local gitMarkReg = [[^\%(<<<<<<<\|=======\|>>>>>>>\)]]

vim.api.nvim_set_keymap('', '[g', '', {
  noremap = true,
  callback = function()
    for _ = 1, vim.v.count1 do
      vim.fn.search(gitMarkReg, 'wb')
    end
  end,
  desc = 'goto previous [count]th git marker',
})

vim.api.nvim_set_keymap('o', '[g', ":<C-u>exe 'norm V'..v:count..'[g'<CR>", {
  noremap = true,
  desc = 'goto previous [count]th git marker (textobject)'
})

vim.api.nvim_set_keymap('', ']g', '', {
  noremap = true,
  callback = function()
    for _ = 1, vim.v.count1 do
      vim.fn.search(gitMarkReg, 'w')
    end
  end,
  desc = 'goto next [count]th git marker',
})

vim.api.nvim_set_keymap('o', ']g', ":<C-u>exe 'norm V'..v:count..']g'<CR>", {
  noremap = true,
  desc = 'goto next [count]th git marker (textobject)'
})

vim.api.nvim_set_keymap('', '[G', '', {
  noremap = true,
  callback = function()
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.fn.search(gitMarkReg, 'wc')
  end,
  desc = 'goto first git marker'
})

vim.api.nvim_set_keymap('', ']G', '', {
  noremap = true,
  callback = function()
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
    vim.fn.search(gitMarkReg, 'wbc')
  end,
  desc = 'goto last git marker'
})

-- buffer jump

vim.api.nvim_set_keymap('n', '[b', ":<C-u>execute v:count..'bprevious'<CR>", {
  noremap = true,
  silent = true,
  desc = 'goto [count]th previous buffer'
})

vim.api.nvim_set_keymap('n', ']b', ":<C-u>execute v:count..'bnext'<CR>", {
  noremap = true,
  silent = true,
  desc = 'goto [count]th next buffer'
})

vim.api.nvim_set_keymap('n', '[B', '<Cmd>bfirst<CR>', {
  noremap = true,
  desc = 'goto first buffer'
})

vim.api.nvim_set_keymap('n', ']B', '<Cmd>blast<CR>', {
  noremap = true,
  desc = 'goto last buffer'
})

-- arg jump

vim.api.nvim_set_keymap('n', "[a", ":<C-u>execute v:count..'previous'<CR>", {
  noremap = true,
  silent = true,
  desc = 'goto [count]th previous argument'
})

vim.api.nvim_set_keymap('n', "]a", ":<C-u>execute v:count..'next'<cr>", {
  noremap = true,
  silent = true,
  desc = 'goto [count]th next argument'
})

vim.api.nvim_set_keymap('n', '[A', '<Cmd>first<CR>', {
  noremap = true,
  desc = 'goto first argument'
})

vim.api.nvim_set_keymap('n', ']A', '<Cmd>last<CR>', {
  noremap = true,
  desc = 'goto last argument'
})

-- file jump

vim.api.nvim_set_keymap('n', ']f', ':call maps#nextFile(1)<CR>', {
  noremap = true,
  silent = true,
  desc = 'edit next file in current file\'s dir'
})

vim.api.nvim_set_keymap('n', '[f', ':call maps#nextFile(0)<CR>', {
  noremap = true,
  silent = true,
  desc = 'edit previous file in current file\'s dir'
})

-- spell

vim.api.nvim_set_keymap('n', '<M-s>', '[s1z=``:sil! call repeat#set("\\<M-s>")<CR>', {
  noremap = true,
  silent = true,
  desc = 'fix previous spell error'
})

vim.api.nvim_set_keymap('i', '<M-s>', '', {
  callback = function()
    local ecol = vim.fn.col '$'
    local lin, col = unpack(vim.api.nvim_win_get_cursor(0))
    col = col + 1
    local exp = ecol == col and 'A' or string.format("gi<C-r>=[''][setcursorcharpos(%d,%d+col('$'))]<CR>", lin, col - ecol)
    return '<Esc>[s1z=``' .. exp
  end,
  noremap = true,
  silent = true,
  expr = true,
  desc = 'fix previous spell error (insert mode)'
})

vim.api.nvim_set_keymap('n', '<M-S>', [[[SzG``:sil! call repeat#set("\<C-s>gh")<CR>]], {
  noremap = true,
  silent = true,
  desc = 'set previous spelling mistake as good (internal)'
})

vim.api.nvim_set_keymap('i', '<M-S>', '', {
  callback = function()
    local ecol = vim.fn.col '$'
    local lin, col = unpack(vim.api.nvim_win_get_cursor(0))
    col = col + 1
    local exp = ecol == col and 'A' or string.format("gi<C-r>=[''][setcursorcharpos(%d,%d+col('$'))]<CR>", lin, col - ecol)
    return '<Esc>[szG``' .. exp
  end,
  noremap = true,
  silent = true,
  expr = true,
  desc = 'set previous spelling mistake as good (internal, insert mode)'
})

-- searching

vim.api.nvim_set_keymap('n', '*', [[<Cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<CR>n]], {
  noremap = true,
  desc = 'search forwards (like * but respect caps)'
})

vim.api.nvim_set_keymap('n', '#',
  [[<Cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<bar>call search('', 'bc')<CR>N]], {
    noremap = true,
    desc = 'search backwards (like # but respect caps)'
  })

vim.api.nvim_set_keymap('n', 'g*', [[<Cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<CR>n]], {
  noremap = true,
  desc = "* without \\< and \\>"
})

vim.api.nvim_set_keymap('n', 'g#', [[<Cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<bar>call search('', 'bc')<CR>n]], {
  noremap = true,
  desc = "# without \\< and \\>"
})

vim.api.nvim_set_keymap('n', '<LocalLeader>*', '*', {
  noremap = true,
  desc = 'original forwards search backup'
})
vim.api.nvim_set_keymap('n', '<LocalLeader>#', '#', {
  noremap = true,
  desc = 'original backwards search backup'
})
vim.api.nvim_set_keymap('n', '<LocalLeader>g*', 'g*', {
  noremap = true,
  desc = 'original forwards no-bounds search backup'
})
vim.api.nvim_set_keymap('n', '<LocalLeader>g#', 'g#', {
  noremap = true,
  desc = 'original backwards no-bounds search backup'
})
vim.api.nvim_set_keymap('n', '<LocalLeader>n', 'n', {
  noremap = true,
  desc = 'original forwards search'
})
vim.api.nvim_set_keymap('n', '<LocalLeader>N', 'N', {
  noremap = true,
  desc = 'original backwards search'
})


-- faster *N{operator}gn{replacementText} using */#/g*/g# as pending operators
--   eg: c*BAR<Esc>.. changes "foo hi foo hi foo" to "BAR hi BAR hi BAR"
--   notes: . = dot operator and cursor starts on first 'foo' in example

vim.api.nvim_set_keymap('o', '*', '', {
  callback = function()
    vim.fn.setreg('/', '\\<' .. vim.fn.expand '<cword>' .. '\\>\\C')
    vim.v.hlsearch = true
    vim.v.searchforward = true
    return "gn"
  end,
  noremap = true,
  silent = true,
  expr = true,
  desc = '<cword> (w/ bounds) text object to replace *Ncgn with c*'
})

vim.api.nvim_set_keymap('o', '#', '', {
  callback = function()
    vim.fn.setreg('/', '\\<' .. vim.fn.expand '<cword>' .. '\\>\\C')
    vim.v.hlsearch = true
    vim.v.searchforward = false
    return "gN"
  end,
  noremap = true,
  silent = true,
  expr = true,
  desc = '<cword> (w/ bounds) text object to replace *NcgN with c#'
})


vim.api.nvim_set_keymap('o', 'g*', '', {
  callback = function()
    vim.fn.setreg('/', vim.fn.expand '<cword>')
    vim.v.hlsearch = true
    vim.v.searchforward = true
  end,
  noremap = true,
  silent = true,
  expr = true,
  desc = '<cword> (w/o bounds) text object to replace g*Ncgn with cg*'
})

vim.api.nvim_set_keymap('o', 'g#', '', {
  callback = function()
    vim.fn.setreg('/', vim.fn.expand '<cword>')
    vim.v.hlsearch = true
    vim.v.searchforward = false
  end,
  noremap = true,
  silent = true,
  expr = true,
  desc = '<cword> (w/o bounds) text object to replace g*NcgN with cg#'
})

vim.api.nvim_set_keymap('', 'n', '', {
  noremap = true,
  callback = function()
    return vim.v.searchforward ~= 0 and 'n' or 'N'
  end,
  expr = true,
  desc = 'always search forwards'
})

vim.api.nvim_set_keymap('', 'N', '', {
  noremap = true,
  callback = function()
    return vim.v.searchforward ~= 0 and 'N' or 'n'
  end,
  expr = true,
  desc = 'always search backwards'
})

-- command line

vim.api.nvim_set_keymap('c', '<M-h>', '<left>', {
  noremap = true,
  desc = 'go left in cmdline'
})

vim.api.nvim_set_keymap('c', '<M-l>', '<right>', {
  noremap = true,
  desc = 'go right in cmdline'
})

vim.api.nvim_set_keymap('c', '<M-k>', '<up>', {
  noremap = true,
  desc = 'go up in cmdline'
})

vim.api.nvim_set_keymap('c', '<M-j>', '<down>', {
  noremap = true,
  desc = 'go down in cmdline'
})

vim.api.nvim_set_keymap('c', '<M-b>', '<C-left>', {
  noremap = true,
  desc = 'go a word left in cmdline'
})

vim.api.nvim_set_keymap('c', '<M-f>', '<C-right>', {
  noremap = true,
  desc = 'go a word right in cmdline'
})

vim.api.nvim_set_keymap('c', '<M-a>', '<C-b>', {
  noremap = true,
  desc = 'go to beginning of cmdline'
})

vim.api.nvim_set_keymap('c', '<M-e>', '<C-e>', {
  noremap = true,
  desc = 'go to end of cmdline'
})

-- simple text objects

vim.api.nvim_set_keymap('x', 'il', '<Esc>g_v^', {
  noremap = true,
  desc = 'in-line text object (visual)'
})

vim.api.nvim_set_keymap('o', 'il', '<Cmd>norm!g_v^<Cr>', {
  noremap = true,
  desc = 'in-line text object (operator-pending)'
})

vim.api.nvim_set_keymap('x', 'al', '<Esc>$v0', {
  noremap = true,
  desc = 'around-line text object (visual)'
})

vim.api.nvim_set_keymap('o', 'al', '<Cmd>norm!$v0<Cr>', {
  noremap = true,
  desc = 'around-line text object (operator-pending)'
})

vim.api.nvim_set_keymap('x', 'id', '<Esc>G$Vgg0', {
  noremap = true,
  desc = 'in-document text object (visual)'
})

vim.api.nvim_set_keymap('o', 'id', '<Cmd>norm!G$Vgg0<Cr>', {
  noremap = true,
  desc = 'in-document text object (operator-pending)'
})

-- visual (block) column/line alignment to other corner
--
--   ↓ other corner's column
--   o----------------+ ← other corner's line
--   | ~~~ ~~ ~~~ ~~~ |
--   | ~ ~~ ~~~~ ~~   | } visual selection
--   | ~~ ~~~         |
--   +----------------x ← current corner's line
--                    ↑ current corner's column
--
--   note: below '.' represents the previous position of current/other visual corner
--   note: the diagrams below illustrate how the visual selection changes for their corresponding bindings

-- go: goto other column
--   o
--   | ~~~ ~~ ~~~ ~~~
--   | ~ ~~ ~~~~ ~~
--   | ~~ ~~~
--   x ←              .
vim.api.nvim_set_keymap('x', 'go', '', {
  callback = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'nx', false)
    vim.api.nvim_feedkeys('gvo', 'nx', false)
    vim.api.nvim_feedkeys('o' .. vim.fn.col '.' .. '|', 'nx', false)
  end,
  noremap = true,
  desc = "Go to Other - realign visual[block]'s current corner's column to other corner's column"
})

-- gO: grab other column
--   .              → o
--     ~~~ ~~ ~~~ ~~~ |
--     ~ ~~ ~~~~ ~~   |
--     ~~ ~~~         |
--                    x
vim.api.nvim_set_keymap('x', 'gO', '', {
  callback = function()
    vim.api.nvim_feedkeys('o' .. vim.fn.virtcol '.' .. '|o', 'nx', false)
  end,
  noremap = true,
  desc = "Grab Other corner - realign visual[block]'s other corner 's columnto current corner's column"
})

-- gl: goto other line
--   o----------------x
--     ~~~ ~~ ~~~ ~~~ ↑
--     ~ ~~ ~~~~ ~~
--     ~~ ~~~
--                    .
vim.api.nvim_set_keymap('x', 'gl', '', {
  callback = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'nx', false)
    vim.api.nvim_feedkeys('gvo', 'nx', false)
    vim.api.nvim_feedkeys('o' .. vim.fn.line '.' .. 'G', 'nx', false)
  end,
  noremap = true,
  desc = "Go to other Line - realign visual's current corner's line to other corner's line"
})

-- gL: grab other line
--   .
--     ~~~ ~~ ~~~ ~~~
--     ~ ~~ ~~~~ ~~
--   ↓ ~~ ~~~
--   o----------------x
vim.api.nvim_set_keymap('x', 'gL', '', {
  callback = function()
    vim.api.nvim_feedkeys('o' .. vim.fn.line '.' .. 'Go', 'nx', false)
  end,
  noremap = true,
  desc = "Grab other Line - realign visual's other corner's line to current corner's line"
})

-- number text objects (eg: cin40 on/before "65" -> "40")

vim.keymap.set({ 'x', 'o' }, 'in', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'nx', false)
  local lineNr = vim.fn.line '.'
  if vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'ce', lineNr) == 0 then
    vim.api.nvim_err_writeln 'no number found on line'
    -- cancel operator
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'L', false)
  end
  vim.api.nvim_feedkeys('v', 'nx', false)
  vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'cb', lineNr)
end, {
  silent = true,
  desc = 'In Number text object'
})

vim.keymap.set({ 'x', 'o' }, 'an', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'nx', false)
  local lineNr = vim.fn.line '.'
  if vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'ce', lineNr) == 0 then
    vim.api.nvim_err_writeln 'no number found on line'
    -- cancel operator
    return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'L', false)
  end
  vim.fn.search([[\%]] .. (vim.fn.virtcol '.' + 1) .. [[v\s*]], 'ce', lineNr)
  vim.api.nvim_feedkeys('v', 'nx', false)
  vim.fn.search([[0b[01]\+\|0x\x\+\|\d\+]], 'cb', lineNr)
  vim.fn.search([[\s*\%]] .. vim.fn.virtcol '.' .. 'v', 'b', lineNr)
end, {
  desc = 'Around Number text object'
})

-- indentation text objects

vim.keymap.set({ 'x', 'o' }, 'ii', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>^', true, true, true), 'nx', false)
  local vCol = vim.fn.virtcol(string.find(vim.fn.getline '.', '^%s*$') and '$' or '.')
  local pat = [[^\(\s*\%]] .. vCol .. [[v\|^$\)\@!]]
  local pstart = vim.fn.search(pat, 'bWn') + 1
  local pend = vim.fn.search(pat, 'Wn')
  if pend ~= 0 then
    pend = pend - 1
  end
  vim.api.nvim_win_set_cursor(0, { pstart, 0 })
  vim.fn.search('^[^\\n\\r]', 'Wc')
  vim.api.nvim_feedkeys('Vo' .. pend .. 'G', 'nx', false)
  vim.fn.search('^[^\\n\\r]', 'bWc')
  vim.api.nvim_feedkeys('$o', 'nx', false)
end, {
  desc = 'In Indendation text object'
})

vim.keymap.set({ 'x', 'o' }, 'ai', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>^', true, true, true), 'nx', false)
  local vCol = vim.fn.virtcol(string.find(vim.fn.getline '.', '^%s*$') and '$' or '.')
  local pat = [[^\(\s*\%]] .. vCol .. [[v\|^$\)\@!]]
  print('pat', pat)
  local pstart = vim.fn.search(pat, 'bWn') + 1
  local pend = vim.fn.search(pat, 'Wn')
  if pend ~= 0 then
    pend = pend - 1
  end
  vim.api.nvim_win_set_cursor(0, { pstart, 0 })
  vim.api.nvim_feedkeys('V' .. pend .. 'G$o', 'nx', false)
end, {
  desc = 'Around Indentation text object'
})

-- cmdline abbreviations (egs, :vhelp => :vert help, :tsbn => :tab sbn)

local function vtca(ab)
  local l = ab:lower()
  vim.api.nvim_set_keymap('ca', 'v' .. l,
    string.format("getcmdline() == 'v%s' && getcmdtype() == ':' && getcmdpos() is %d ? 'vert %s' : 'v%s'", l, #ab + 2,
      ab, l), {
      noremap = true,
      expr = true,
      desc = ':vert ' .. ab .. ' abbrev hack (beg. of line only)'
    })
  vim.api.nvim_set_keymap('ca', 't' .. l,
    string.format("getcmdline() == 't%s' && getcmdtype() == ':' && getcmdpos() is %d ? 'tab %s' : 't%s'", ab, #ab + 2,
      ab, l), {
      noremap = true,
      expr = true,
      desc = ':tab ' .. ab .. ' abbrev hack (beg. of line only)'
    })
end

vim.iter(vim.gsplit(
  'al:l ba:ll diffs:plit dsp:lit h:elp isp:lit sN:ext sa:rgument sal:l sbN:ext sb:uffer sba:ll sbf:irst sbl:ast sbm:odified sbn:ext sbp:revious sbr:ewind sf:ind sfi sfi:rst sla:st sn:xt splitfind spr:evious sre:wind sta:g stj:ump sts:elect sv:iew Man',
  '%s'))
    :each(function(w)
      local ab, r = w:match '^(%S+):(%S-)$'
      if ab == nil then ab = w end
      vtca(ab)
      if r ~= nil then vtca(ab .. r) end
    end)

-- abbreviations for typos

vim.api.nvim_set_keymap('ia', 'unkown', 'unknown', {
  noremap = true,
  desc = 'unkown => unknown abbrev'
})
