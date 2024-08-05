-- leader fix

vim.keymap.set('n', '<Leader>', '', {
  desc = 'map <Leader> to <Nop> to fix side effects'
})

-- save

vim.keymap.set({ 'n', 'x', 'i', 'c' }, '<M-w>', '<Cmd>silent update<CR>', {
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

vim.keymap.set('n', '<LocalLeader>q', '<Cmd>qall<CR>', {
  desc = 'quit quickly if no unsaved files'
})

-- source

vim.keymap.set('n', '<LocalLeader>s', '<Cmd>source %<CR>', {
  desc = 'source current file'
})

-- overload <C-l>

vim.keymap.set('n', "<C-l>", "<Cmd>nohlsearch | diffupdate | redraw! | echon ''<CR>", {
  desc = '<C-l> clears search hls, updates diffs, and redraws'
})

-- previous command

vim.keymap.set({ 'n', 'x' }, '<C-p>', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':<Up>', true, true, true), 'tx!', false)
end, {
  desc = 'open command-line and go <Up> to last command' -- this works in visual mode, too
})

-- recursive zO on open fold

vim.keymap.set('n', 'zO', "foldclosed('.') == -1 ? 'zczO' : 'zO'", {
  expr = true,
  silent = true,
  desc = 'like zO but close an open fold first to trigger recursive gO'
})

-- ix.io pastebin

vim.keymap.set('n', '<LocalLeader>B', ':set opfunc=maps#pastebin<CR>g@', {
  silent = true,
  desc = 'paste next text object to ix.io'
})

vim.keymap.set('n', '<LocalLeader>BB', 'V<space>B', {
  remap = true,
  silent = true,
  desc = 'paste current line to ix.io'
})

vim.keymap.set('x', '<LocalLeader>B', ':<C-u>call maps#pastebin(visualmode())<CR>', {
  silent = true,
  desc = 'paste visual selection to ix.io'
})

-- loclist jump

vim.keymap.set('n', "[w", ":<C-u>execute v:count..'lprevious'<CR>", {
  silent = true,
  desc = 'goto [count]th previous loclist error'
})

vim.keymap.set('n', "]w", ":<C-u>execute v:count..'lnext'<CR>", {
  silent = true,
  desc = 'goto [count]th next loclist error'
})

-- quickfix jump

vim.keymap.set('n', "[q", ":<C-u>execute v:count..'cprevious'<CR>", {
  silent = true,
  desc = '<count>cprevious'
})

vim.keymap.set('n', "]q", ":<C-u>execute v:count..'cnext'<CR>", {
  silent = true,
  desc = '<count>cnext'
})

-- line move

vim.keymap.set('n', '[e', ':<C-u>call maps#moveLine(0, v:count, 0)<CR>', {
  silent = true,
  desc = 'move current line up [count]th lines'
})

vim.keymap.set('x', '[e', ':<C-u>call maps#moveLine(0, v:count, 1)<CR>', {
  silent = true,
  desc = 'move selection up [count]th lines'
})

vim.keymap.set('n', ']e', ':<C-u>call maps#moveLine(1, v:count, 0)<CR>', {
  silent = true,
  desc = 'move current line down [count]th lines'
})

vim.keymap.set('x', ']e', ':<C-u>call maps#moveLine(1, v:count, 1)<CR>', {
  silent = true,
  desc = 'move selection down [count]th lines'
})

-- git jump

local gitMarkReg = [[^\%(<<<<<<<\|=======\|>>>>>>>\)]]

vim.keymap.set({ 'n', 'x' }, '[g', function()
  for _ = 1, vim.v.count1 do
    vim.fn.search(gitMarkReg, 'wb')
  end
end, {
  desc = 'goto previous [count]th git marker',
})

vim.keymap.set('o', '[g', ":<C-u>exe 'norm V'..v:count..'[g'<CR>", {
  desc = 'goto previous [count]th git marker (textobject)'
})

vim.keymap.set({ 'n', 'x' }, ']g', function()
  for _ = 1, vim.v.count1 do
    vim.fn.search(gitMarkReg, 'w')
  end
end, {
  desc = 'goto next [count]th git marker',
})

vim.keymap.set('o', ']g', ":<C-u>exe 'norm V'..v:count..']g'<CR>", {
  desc = 'goto next [count]th git marker (textobject)'
})

vim.keymap.set({ 'n', 'x', 'o' }, '[G', function()
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.fn.search(gitMarkReg, 'wc')
end, {
  desc = 'goto first git marker'
})

vim.keymap.set({ 'n', 'x', 'o' }, ']G', function()
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  vim.fn.search(gitMarkReg, 'wbc')
end, {
  desc = 'goto last git marker'
})

-- buffer jump

vim.keymap.set('n', '[b', ":<C-u>execute v:count..'bprevious'<CR>", {
  silent = true,
  desc = 'goto [count]th previous buffer'
})

vim.keymap.set('n', ']b', ":<C-u>execute v:count..'bnext'<CR>", {
  silent = true,
  desc = 'goto [count]th next buffer'
})

vim.keymap.set('n', '[B', '<Cmd>bfirst<CR>', {
  desc = 'goto first buffer'
})

vim.keymap.set('n', ']B', '<Cmd>blast<CR>', {
  desc = 'goto last buffer'
})

-- arg jump

vim.keymap.set('n', "[a", ":<C-u>execute v:count..'previous'<CR>", {
  silent = true,
  desc = 'goto [count]th previous argument'
})

vim.keymap.set('n', "]a", ":<C-u>execute v:count..'next'<cr>", {
  silent = true,
  desc = 'goto [count]th next argument'
})

vim.keymap.set('n', '[A', '<Cmd>first<CR>', {
  desc = 'goto first argument'
})

vim.keymap.set('n', ']A', '<Cmd>last<CR>', {
  desc = 'goto last argument'
})

-- file jump

vim.keymap.set('n', ']f', ':call maps#nextFile(1)<CR>', {
  silent = true,
  desc = 'edit next file in current file\'s dir'
})

vim.keymap.set('n', '[f', ':call maps#nextFile(0)<CR>', {
  silent = true,
  desc = 'edit previous file in current file\'s dir'
})

-- fzf

vim.keymap.set('n', '<Leader>f', function()
  require 'fzf-lua'.files()
end, {
  desc = 'browse all files in cwd in fzf-lua'
})

vim.keymap.set('n', '<LocalLeader>c', function()
  require 'fzf-lua'.files { cwd = vim.fn.stdpath 'config' }
end, {
  desc = 'browse files in config in fzf-lua'
})

-- spell

vim.keymap.set('n', '<M-s>', '[s1z=``:sil! call repeat#set("\\<M-s>")<CR>', {
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
  desc = 'fix previous spell error (insert mode)'
})

vim.keymap.set('n', '<M-S>', [[[SzG``:sil! call repeat#set("\<C-s>gh")<CR>]], {
  silent = true,
  desc = 'set previous spelling mistake as good (internal)'
})

vim.keymap.set('i', '<M-S>', function()
  local ecol = vim.fn.col '$'
  local lin, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col + 1
  local exp = ecol == col and 'A' or string.format("gi<C-r>=[''][setcursorcharpos(%d,%d+col('$'))]<CR>", lin, col - ecol)
  return '<Esc>[szG``' .. exp
end, {
  silent = true,
  expr = true,
  desc = 'set previous spelling mistake as good (internal, insert mode)'
})

-- searching

vim.keymap.set('n', '*', [[<Cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<CR>n]], {
  desc = 'search forwards (like * but respect caps)'
})

vim.keymap.set('n', '#',
  [[<Cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<bar>call search('', 'bc')<CR>N]], {
    desc = 'search backwards (like # but respect caps)'
  })

vim.keymap.set('n', 'g*', [[<Cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<CR>n]], {
  desc = "* without \\< and \\>"
})

vim.keymap.set('n', 'g#', [[<Cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<bar>call search('', 'bc')<CR>n]], {
  desc = "# without \\< and \\>"
})

vim.keymap.set('n', '<Leader>*', '*', { desc = 'original forwards search backup' })
vim.keymap.set('n', '<Leader>#', '#', { desc = 'original backwards search backup' })
vim.keymap.set('n', '<Leader>g*', 'g*', { desc = 'original forwards no-bounds search backup' })
vim.keymap.set('n', '<Leader>g#', 'g#', { desc = 'original backwards no-bounds search backup' })
vim.keymap.set('n', '<Leader>n', 'n', { desc = 'original forwards search' })
vim.keymap.set('n', '<Leader>N', 'N', { desc = 'original backwards search' })


-- faster *N{operator}gn{replacementText} using */#/g*/g# as pending operators
--   eg: c*BAR<Esc>.. changes "foo hi foo hi foo" to "BAR hi BAR hi BAR"
--   notes: . = dot operator and cursor starts on first 'foo' in example

vim.keymap.set('o', '*', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand '<cword>' .. '\\>\\C')
  vim.v.hlsearch = true
  vim.v.searchforward = true
  return "gn"
end, {
  silent = true,
  expr = true,
  desc = '<cword> (w/ bounds) text object to replace *Ncgn with c*'
})

vim.keymap.set('o', '#', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand '<cword>' .. '\\>\\C')
  vim.v.hlsearch = true
  vim.v.searchforward = false
  return "gN"
end, {
  silent = true,
  expr = true,
  desc = '<cword> (w/ bounds) text object to replace *NcgN with c#'
})


vim.keymap.set('o', 'g*', function()
  vim.fn.setreg('/', vim.fn.expand '<cword>')
  vim.v.hlsearch = true
  vim.v.searchforward = true
end, {
  silent = true,
  expr = true,
  desc = '<cword> (w/o bounds) text object to replace g*Ncgn with cg*'
})

vim.keymap.set('o', 'g#', function()
  vim.fn.setreg('/', vim.fn.expand '<cword>')
  vim.v.hlsearch = true
  vim.v.searchforward = false
end, {
  silent = true,
  expr = true,
  desc = '<cword> (w/o bounds) text object to replace g*NcgN with cg#'
})

vim.keymap.set({ 'n', 'x', 'o' }, 'n', function()
  return vim.v.searchforward ~= 0 and 'n' or 'N'
end, {
  expr = true,
  desc = 'always search forwards'
})

vim.keymap.set({ 'n', 'x', 'o' }, 'N', function()
  return vim.v.searchforward ~= 0 and 'N' or 'n'
end, {
  expr = true,
  desc = 'always search backwards'
})

-- command line

vim.keymap.set('c', '<M-h>', '<left>', {
  desc = 'go left in cmdline'
})

vim.keymap.set('c', '<M-l>', '<right>', {
  desc = 'go right in cmdline'
})

vim.keymap.set('c', '<M-k>', '<up>', {
  desc = 'go up in cmdline'
})

vim.keymap.set('c', '<M-j>', '<down>', {
  desc = 'go down in cmdline'
})

vim.keymap.set('c', '<M-b>', '<C-left>', {
  desc = 'go a word left in cmdline'
})

vim.keymap.set('c', '<M-f>', '<C-right>', {
  desc = 'go a word right in cmdline'
})

vim.keymap.set('c', '<M-a>', '<C-b>', {
  desc = 'go to beginning of cmdline'
})

vim.keymap.set('c', '<M-e>', '<C-e>', {
  desc = 'go to end of cmdline'
})

-- simple text objects

vim.keymap.set('x', 'il', '<Esc>g_v^', {
  desc = 'in-line text object (visual)'
})

vim.keymap.set('o', 'il', '<Cmd>norm!g_v^<Cr>', {
  desc = 'in-line text object (operator-pending)'
})

vim.keymap.set('x', 'al', '<Esc>$v0', {
  desc = 'around-line text object (visual)'
})

vim.keymap.set('o', 'al', '<Cmd>norm!$v0<Cr>', {
  desc = 'around-line text object (operator-pending)'
})

vim.keymap.set('x', 'id', '<Esc>G$Vgg0', {
  desc = 'in-document text object (visual)'
})

vim.keymap.set('o', 'id', '<Cmd>norm!G$Vgg0<Cr>', {
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
vim.keymap.set('x', 'go', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'nx', false)
  vim.api.nvim_feedkeys('gvo', 'nx', false)
  vim.api.nvim_feedkeys('o' .. vim.fn.col '.' .. '|', 'nx', false)
end, {
  desc = "Go to Other - realign visual[block]'s current corner's column to other corner's column"
})

-- gO: grab other column
--   .              → o
--     ~~~ ~~ ~~~ ~~~ |
--     ~ ~~ ~~~~ ~~   |
--     ~~ ~~~         |
--                    x
vim.keymap.set('x', 'gO', function()
  vim.api.nvim_feedkeys('o' .. vim.fn.virtcol '.' .. '|o', 'nx', false)
end, {
  desc = "Grab Other corner - realign visual[block]'s other corner 's columnto current corner's column"
})

-- gl: goto other line
--   o----------------x
--     ~~~ ~~ ~~~ ~~~ ↑
--     ~ ~~ ~~~~ ~~
--     ~~ ~~~
--                    .
vim.keymap.set('x', 'gl', function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-Bslash><C-n>', true, true, true), 'nx', false)
  vim.api.nvim_feedkeys('gvo', 'nx', false)
  vim.api.nvim_feedkeys('o' .. vim.fn.line '.' .. 'G', 'nx', false)
end, {
  desc = "Go to other Line - realign visual's current corner's line to other corner's line"
})

-- gL: grab other line
--   .
--     ~~~ ~~ ~~~ ~~~
--     ~ ~~ ~~~~ ~~
--   ↓ ~~ ~~~
--   o----------------x
vim.keymap.set('x', 'gL', function()
  vim.api.nvim_feedkeys('o' .. vim.fn.line '.' .. 'Go', 'nx', false)
end, {
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

-- cmdline abbreviations (egs, :vhelp => :vert help, :vsbn => :vert sbn)

local function vca(ab)
  vim.keymap.set('ca', 'v' .. ab,
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

vim.keymap.set('ia', 'unkown', 'unknown', {
  desc = 'unkown => unknown abbrev'
})
