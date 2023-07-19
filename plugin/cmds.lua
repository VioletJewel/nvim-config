-- Author: Violet
-- Last Change: 12 July 2023

local cmd = vim.api.nvim_create_user_command
local opts

opts = { bang=true, bar=true, nargs='?' }
cmd('Q'  , 'q<bang> <args>'  , opts)
cmd('QA' , 'qa<bang> <args>' , opts)
cmd('Qa' , 'qa<bang> <args>' , opts)
cmd('WQ' , 'wq<bang> <args>' , opts)
cmd('Wq' , 'wq<bang> <args>' , opts)
cmd('WQA', 'wqa<bang> <args>', opts)
cmd('WQa', 'wqa<bang> <args>', opts)
cmd('Wqa', 'wqa<bang> <args>', opts)

-- :{arg,buf,win}do without mucking syntax or changing buffers
opts = { nargs='+' }
cmd('Argdo', 'call cmds#ArgDo(<q-args>)', opts)
cmd('Bufdo', 'call cmds#BufDo(<q-args>)', opts)
cmd('Windo', 'call cmds#WinDo(<q-args>)', opts)

-- preserve view while executing some command
cmd('Keepview', table.concat({
  'let g:viewsav=winsaveview()',
  'exe escape(<q-args>, \'\\"\')',
  'call winrestview(g:viewsav)',
  'unlet g:viewsav',
  }, '|'), { nargs=1, bar=true })

-- search all args with :grep or :vimgrep (do NOT use on big files)
opts = { nargs='+', bar=true }
cmd('ArgGrep'   , 'call cmds#FilelistGrep(<q-args>, argv())'   , opts)
cmd('ArgVimgrep', 'call cmds#FilelistVimgrep(<q-args>, argv())', opts)

-- search all listed buffers with :grep or :vimgrep (do NOT use on big files)
cmd('BufGrep'   , 'call cmds#FilelistGrep(<q-args>, filter(range(1, bufnr("$")), funcref("cmds#Bufcheck")))', opts)
cmd('BufVimgrep', 'call cmds#FilelistVimgrep(<q-args>, filter(range(1, bufnr("$")), funcref("cmds#Bufcheck")))', opts)

-- put an ex command - eg :Put version
opts = { range=true, nargs='+', complete='command' }
cmd('Put' , 'call cmds#Put(<q-args>, <line1>, getcurpos(), 0, "")', opts)
cmd('Sput', 'call cmds#Put(<q-args>, <line1>, getcurpos(), 1, <q-mods>)', opts)

-- still synchronous but quieter make
opts = { bar=true, nargs='?' }
cmd('Make' , 'call cmds#Make(<q-args>)', opts)
cmd('Lmake', 'call cmds#Lmake(<q-args>)', opts)

-- :help :DiffOrig
cmd('DiffOrig', table.concat({
  'vert new',
  'set buftype=nofile',
  'read ++e#',
  '0d_',
  'diffthis',
  'wincmd p',
  'diffthis',
  }, '|'), {})

-- clear quickfix
cmd('Cclear', 'call setqflist([], "r")', { nargs=0 })

cmd('Snip', function(c)
  local f = vim.fn.stdpath('config')..'/lua/snippets/'..(c.args == '' and vim.o.filetype or c.args)..'.lua'
  vim.cmd('edit '..f)
end, {nargs='?'})

cmd('Ssnip', function(c)
  local f = vim.fn.stdpath('config')..'/lua/snippets/'..(c.args == '' and vim.o.filetype or c.args)..'.lua'
  print(vim.inspect( c ))
  vim.api.nvim_cmd({
    cmd = 'split',
    args = { f },
    mods = c.smods,
  }, {})
end, {nargs='?'})
-- cmd('Snip', "execute 'edit' fnameescape(stdpath('config')..'/lua/snippets/'..(empty(<q-args>) ? &filetype : <q-args>)..'.lua')", {nargs='?'})
-- cmd('Ssnip', "execute <q-mods> 'sp' fnameescape(stdpath('config')..'/lua/snippets/'..(empty(<q-args>) ? &filetype : <q-args>)..'.lua')", {nargs='?'})

