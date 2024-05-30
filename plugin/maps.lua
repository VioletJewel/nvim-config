
--- Mappings for neovim.
-- @module plugin/maps

-- cabbrev hack for v{cmd} -> vert {cmd} at beginning of line only
local function vca(ab)
  return {
    string.format("ca v%s getcmdline() == 'v%s' && getcmdtype() == ':' && getcmdpos() is %d ? 'vert %s' : '%s'", ab, ab, #ab+2, ab, ab),
    expr = true,
    desc = 'vert '..ab
  }
end

require'utils'.mapall{

  vca'sb',  vca'sb#',
  vca'h',   vca'h#',
  vca'sn',  vca'sn#',
  vca'spr', vca'spr#',
  vca'sbn', vca'sbn#',
  vca'sbp', vca'sbp#',


  { 'nx <L>', desc='fix leader side effects' },

  -- quick

  { 'nxic <M-w> <Cmd>sil up<CR>', desc='update file quickly', silent=true },
  { 'nxic <M-W> <Cmd>sil noa up<CR>', desc='update file quickly (noautocmd)', silent=true },

  { 'nxic <M-e> <Cmd>sil wa<CR>', desc='write file quickly', silent=true },
  { 'nxic <M-E> <Cmd>sil noa wa<CR>', desc='write file quickly (noautocmd)', silent=true },

  { 'n <LL>q <Cmd>qa<CR>', desc='quit quickly', silent=true },
  { 'n <LL>s <Cmd>sil up|so%<CR>', desc='update and source current file', silent=true },

  { "n <C-l> <cmd>noh|dif|redr!|echon''<cr>", desc='overload <C-l>', silent=true },

  { 'n <C-p> :<C-p>', desc='get to previous command quickly', silent=true },
  { 'x <C-p> :<Up>',  desc='get to previous "visual" command quickly', silent=true },

  { "n zO foldclosed('.') is -1 ? 'zczO' : 'zO'", expr = true,
    desc = 'same as zO but if fold already open, close first', silent=true },

  -- jumping

  { "n [b :<c-u>execute v:count.'bprevious'<cr>", desc='[count] bprevious', silent=true },
  { "n [B :bfirst<cr>", desc='bfirst', silent=true },
  { "n ]b :<c-u>execute v:count.'bnext'<cr>", desc='[count] bnext', silent=true },
  { "n ]B :blast<cr>", desc='blast', silent=true },

  { "n [a :<c-u>execute v:count.'previous'<cr>", desc='[count] previous', silent=true },
  { "n [A :first<cr>", desc='first', silent=true },
  { "n ]a :<c-u>execute v:count.'next'<cr>", desc='[count] next', silent=true },
  { "n ]A :last<cr>", desc='last', silent=true },

  { 'n <l>ww <cmd>call maps#locToggle()<cr>', desc='toggle local list', silent=true },
  { 'n <l>wo :lopen<cr>', desc='open local list', silent=true },
  { 'n <l>wc :lclose<cr>', desc='close local list', silent=true },
  { "n [w :<c-u>execute v:count.'lprevious'<cr>", desc='[count] lprevious', silent=true },
  { 'n [W :lfirst<cr>', desc='lfirst', silent=true },
  { "n ]w :<c-u>execute v:count.'lnext'<cr>", desc='[count] lnext', silent=true },
  { "n ]W :llast<cr>", desc='llast', silent=true },

  { 'n <l>qq <cmd>call maps#qfToggle()<cr>', desc='toggle quickfix list', silent=true },
  { 'n <l>qo :belowright copen<cr>', desc='open quickfix list', silent=true },
  { 'n <l>qc :cclose<cr>', desc='close quickfix list', silent=true },
  { "n [q :<c-u>execute v:count.'cprevious'<cr>", desc='[count] cprevious', silent=true },
  { 'n [Q :cfirst<cr>', desc='cfirst', silent=true },
  { "n ]q :<c-u>execute v:count.'cnext'<cr>", desc='[count] cnext', silent=true },
  { 'n ]Q :clast<cr>', desc='clast', silent=true },

  { 'n [e :<c-u>call maps#moveLine(0, v:count, 0)<cr>', desc='move line up', silent=true },
  { 'x [e :<c-u>call maps#moveLine(0, v:count, 1)<cr>', desc='move selection up', silent=true },

  { 'n ]e :<c-u>call maps#moveLine(1, v:count, 0)<cr>', desc='move line down', silent=true },
  { 'x ]e :<c-u>call maps#moveLine(1, v:count, 1)<cr>', desc='move selection down', silent=true },

  { "n [g call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb)<cr>", desc='jump to next git marker', silent=true },
  { "n ]g :call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>", desc='jump to previous git marker', silent=true },

  { 'n ]f :call maps#nextFile(1)<cr>', desc='edit next file in directory', silent=true },
  { 'n [f :call maps#nextFile(0)<cr>', desc='edit previous file in directory', silent=true },

  -- fzf

  { 'n <l>f', function() require'fzf-lua'.files() end, desc='browse ./**' },
  -- { 'n <l>F <cmd>History<cr>', desc='browse oldfiles' },
  { 'n <ll>f', function() require'fzf-lua'.files() end, desc='browse %:p:h/**', },
  -- { 'n <ll>F :Files %:p:h<c-z>', desc='browse %:p:h/** but wait for user', },
  { 'n <l>b <cmd>Buffers<cr>', desc='switch buffers', },

  { 'n <ll>c', function() require'fzf-lua'.files{ cwd = vim.fn.stdpath'config' } end,
    desc='edit files in config' },

  -- spell

  { 'i   <c-s> <esc>[s1z=gi', desc='quickly fix prev spell error in insert mode', silent=true },
  { 'n <c-s>h [s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', desc='fix prev spell error (repeatable)', silent=true },
  { 'n <c-s>l ]s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', desc='fix next spell error (repeatable)', silent=true },

  -- spell gooding (repeatable)
  { [[n <c-s>gh [Szg``:sil! call repeat#set("\<c-s>gh")<cr>]] },
  { [[n <c-s>gl ]Szg``:sil! call repeat#set("\<c-s>gl")<cr>]] },
  { [[n <c-s>Gh [SzG``:sil! call repeat#set("\<c-s>Gh")<cr>]] },
  { [[n <c-s>Gl ]SzG``:sil! call repeat#set("\<c-s>Gl")<cr>]] },

  -- searching

  { [[n * <cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<cr>]],
    desc=[["* but respect capitalization; don't move cursor"]] },
  { [[n # <cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<bar>call search('', 'bc')<cr>]],
    desc=[["# but respect capitalization; move cursor to beg of word"]] },
  { [[n g* <cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<cr>]],
    desc=[["g* without \< and \>"]] },
  { [[n g# <cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<bar>call search('', 'bc')<cr>]],
    desc=[["g# without \< and \>"]] },

  { 'o *  maps#stargn(1)', desc='"faster *N{op}gn"', silent=true, expr=true },
  { 'o #  maps#stargn(1)', desc='"faster #N{op}gn"', silent=true, expr=true },
  { 'o g* maps#stargn(0)', desc='"faster g*N{op}gn"', silent=true, expr=true  },
  { 'o g# maps#stargn(0)', desc='"faster g#N{op}gn"', silent=true, expr=true  },

  { 'nxo n', function() return vim.v.searchforward ~= 0 and 'n' or 'N' end, expr=true },
  { 'nxo N', function() return vim.v.searchforward ~= 0 and 'N' or 'n' end, expr=true },

  -- command line

  { 'c <M-h> <left>',  desc='go left in cmdline' },
  { 'c <M-l> <right>', desc='go right in cmdline' },

  { 'c <M-k> <up>',   desc='go up in cmdline' },
  { 'c <M-j> <down>', desc='go down in cmdline' },

  { 'c <M-b> <c-left>',  desc='go a word left in cmdline' },
  { 'c <M-f> <c-right>', desc='go a word right in cmdline' },

  { 'c <M-a> <c-b>', desc='go to beginning of cmdline' },
  { 'c <M-e> <c-e>', desc='go to end of cmdline' },

  -- text objects

  { 'x il <Esc>g_v^', desc='in-line text object' },
  { 'o il <Cmd>norm!g_v^<Cr>', desc='in-line text object' },

  { 'x al <Esc>$v0', desc='around-line text object' },
  { 'o al <Cmd>norm!$v0<Cr>', desc='around-line text object' },

  { 'x id <Esc>G$Vgg0', desc='in-document text object' },
  { 'o id <Cmd>norm!G$Vgg0<Cr>', desc='in-document text object' },

  { 'x  go <cmd>call maps#visualGoOther(0)<cr>' },
  { 'x  gO <cmd>call maps#visualGoOther(1)<cr>' },

  { 'x  gl <cmd>call maps#visualGoLine(0)<cr>' },
  { 'x  gL <cmd>call maps#visualGoLine(1)<cr>' },

  { 'xo in <cmd>call maps#inNumber()<cr>' },
  { 'xo an <cmd>call maps#aroundNumber()<cr>' },

  { 'xo ii <cmd>call maps#inIndentation()<cr>' },
  { 'xo ai <cmd>call maps#aroundIndentation()<cr>' },

  -- visual go commands

  {
    'x go', function()
      vim.cmd.normal{
        vim.api.nvim_replace_termcodes('<c-bslash><c-n>', true, false, true),
        bang=true,
      }
      vim.cmd.normal{'gvo', bang=true,}
      vim.cmd.normal{'o'..vim.fn.col'.'..'|', bang=true,}
    end,
    desc = 'Goto Other [Corner]',
  },

  {
    'x gO', function()
      vim.cmd.normal{'o'..vim.fn.col'.'..'|o', bang=true,}
    end,
    desc = 'Grab Other [Corner]',
  },

}

local ok, ls = pcall(require, 'luasnip')
if ok then
  local e_,e,j_,j,ca_,cc = ls.expandable, ls.expand, ls.jumpable, ls.jump, ls.choice_active, ls.change_choice
  require'utils'.mapall{
    { 'is  <m-space>', function() if e_() then e() end end }, -- 'expand luasnippet'
    { 'isn <m-h>', function() if j_(-1) then j(-1) end end }, -- 'jump to previous luasnip node'
    { 'isn <m-l>', function() if j_(1) then j(1) end end }, -- 'jump to next luasnip node' }
    { 'is <m-j>', function() if ca_() then cc(1) end end }, -- 'cycle forward though luasnip node choices'
    { 'is <m-k>', function() if ca_() then cc(-1) end end }, -- 'cycle backward though luasnip node choices'
  }
end

