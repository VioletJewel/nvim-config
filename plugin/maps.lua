-- Author: Violet
-- Last Change: 11 September 2023

-- setup {{{1


local mapall = require'utils'.mapall
local au = require'utils'.augroup('VioletMaps')

mapall{

  -- main {{{1

  '<l>', -- leader = <nop> (fix side effects)

  ':nix: <m-w> <cmd>sil up<cr>',     -- quietly update file
  ':nix: <m-W> <cmd>sil noa up<cr>', -- quietly update without autocmds

  ':nix: <m-e> <cmd>sil wa<cr>',     -- quietly update all unchanged buffers
  ':nix: <m-E> <cmd>sil noa wa<cr>', -- quietly update all unchanged buffers w/o autocmds

  '<ll>q <cmd>qa<cr>', -- quit unless unsaved changes

  '<remap> <ll>R <c-w>p<c-l><c-p><cr><c-w>p', -- re-run previous command in other (terminal?) window

  "<c-l> <cmd>noh|dif|redr!|echon''<cr>", -- :nohlsearch, :diffupdate, :redraw! all in one
  '<l><c-l> <cmd>syn sync fromstart<cr>', -- sync syntax from beginning of file

  au{ 'CmdlineEnter', callback = function() vim.g._cmdtype_last_ = vim.v.event.cmdtype end },

  "<expr> <c-p> {last->stridx(':/?',last) is -1?':':last}(get(g:,'_cmdtype_last_',':'))..'<c-p>'", -- opens last command or search
  ":x: <c-p> :<c-u>'<,'><up>",                                                                    -- open last command operating on visual selection

  "<expr> zO foldclosed('.') is -1 ? 'zczO' : 'zO'", -- same as zO but if fold already open, close first

  "<sil,expr> <l>; (getline('.')=~#';\\s*$'?'g_x':'g_a;<esc>').virtcol('.').'|'", -- toggle ";" at end of line

  '<m-M> <cmd>sil Make<cr>',  -- quick :Make
  '<m-L> <cmd>sil Lmake<cr>', -- quick :Lmake

  '           <l>p <cmd>call synstack#echo()<cr>', -- print highlight groups
  ':x: <expr> <l>p synstack#vExprPrint()', -- "print stats visual selection (similar to 'showcmd')"

  ':o: w <cmd>call maps#o_word(0)<cr>', -- fix cw/dw inconsistency
  ':o: W <cmd>call maps#o_word(1)<cr>', -- fix cW/dW inconsistency

  {
    ':i:<c-r><c-u>', function()
      local inp = vim.fn.input':Repeat/'
      local sepPos = inp:find'/'
      local amt = inp:sub(1, sepPos-1)
      local str = inp:sub(sepPos+1)
      return ('<c-r>=repeat(%s,%s)<cr>'):format(vim.fn.string(str), amt)
    end,
    silent = true,
    expr = true,
    desc = 'repeat string in insert mode'
  },

  -- search {{{1

  [[* <cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<cr>]], -- "* but respect capitalization; don't move cursor"
  [[# <cmd>let v:hlsearch=setreg('/', '\<'..expand('<cword>')..'\>\C')+1<bar>call search('', 'bc')<cr>]], -- "# but respect capitalization; move cursor to beg of word"
  [[g* <cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<cr>]], -- "g* without \\< and \\>"
  [[g# <cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\C')+1<bar>call search('', 'bc')<cr>]], -- "g# without \\< and \\>"
  ':x: * <esc>*gv', -- use * in visual mode
  ':x: # <esc>#gv', -- use # in visual mode
  ':x: g* <esc>g*gv', -- use g* in visual mode
  ':x: g# <esc>g#gv', -- use g# in visual mode
  --    eg: c*Replacement<esc>.. to replace <cword> with 'Replacement' and repeat twice
  ':o: <sil,expr> *  maps#stargn(1)', -- "faster *N{op}gn"
  ':o: <sil,expr> #  maps#stargn(1)', -- "faster #N{op}gn"
  ':o: <sil,expr> g* maps#stargn(0)',  -- "faster g*N{op}gn"
  ':o: <sil,expr> g# maps#stargn(0)',  -- "faster g#N{op}gn"
  ':x: <l># :<c-u>let v:hlsearch=maps#visSearch()+1<cr>gvo', -- search backward for literal visual selection
  ':x:<l>* :<c-u>let v:hlsearch=maps#visSearch()+1<cr>gv', -- search forward for literal visual selection
  {
    ':nxo:n', function() -- always search forwards
      vim.v.searchforward = 1
      vim.api.nvim_feedkeys('n', 'ntx', false)
      if vim.fn.foldclosed('.') >= 0 then
        vim.cmd'silent! foldopen!'
      end
    end
  },
  {
    ':nxo:N', function() -- always search backwards
      vim.v.searchforward = 1
      vim.api.nvim_feedkeys('N', 'ntx', false)
      if vim.fn.foldclosed('.') >= 0 then
        vim.cmd'silent! foldopen!'
      end
    end
  },
  ":c:<c-t> <c-t><c-r>=execute('sil! foldo!')[-1]<cr>",
  ":c:<c-g> <c-g><c-r>=execute('sil! foldo!')[-1]<cr>",

  -- quick {{{1

  "<sil>[b :<c-u>execute v:count.'bprevious'<cr>", -- [count] bprevious
  "<sil>[B :bfirst<cr>", -- bfirst
  "<sil>]b :<c-u>execute v:count.'bnext'<cr>", -- [count] bnext
  "<sil>]B :blast<cr>", -- blast

  "<sil>[a :<c-u>execute v:count.'previous'<cr>", -- [count] previous
  "<sil>[A :first<cr>", -- first
  "<sil>]a :<c-u>execute v:count.'next'<cr>", -- [count] next
  "<sil>]A :last<cr>", -- last

  '<sil><l>ww <cmd>call maps#locToggle()<cr>', -- toggle local list
  '<sil><l>wo :lopen<cr>', -- open local list
  '<sil><l>wc :lclose<cr>', -- close local list
  "<sil>[w :<c-u>execute v:count.'lprevious'<cr>", -- [count] lprevious
  '<sil>[W :lfirst<cr>', -- lfirst
  "<sil>]w :<c-u>execute v:count.'lnext'<cr>", -- [count] lnext
  "<sil>]W :llast<cr>", -- llast

  '<sil><l>qq <cmd>call maps#qfToggle()<cr>', -- toggle quickfix list
  '<sil><l>qo :belowright copen<cr>', -- open quickfix list
  '<sil><l>qc :cclose<cr>', -- close quickfix list
  "<sil>[q :<c-u>execute v:count.'cprevious'<cr>", -- [count] cprevious
  '<sil>[Q :cfirst<cr>', -- cfirst
  "<sil>]q :<c-u>execute v:count.'cnext'<cr>", -- [count] cnext
  '<sil>]Q :clast<cr>', -- clast

  '<sil>[e :<c-u>call maps#moveLine(0, v:count, 0)<cr>', -- move line up
  ':x:<sil>[e :<c-u>call maps#moveLine(0, v:count, 1)<cr>', -- 'move selection up' }

  '<sil>]e :<c-u>call maps#moveLine(1, v:count, 0)<cr>', -- move line down
  ':x:<sil>]e :<c-u>call maps#moveLine(1, v:count, 1)<cr>', -- move selection down

  "<sil>[g call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb)<cr>", -- jump to next git marker'
  "<sil>]g :call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>", -- jump to previous git marker


  '<sil>]f :call maps#nextFile(1)<cr>', -- edit next file in directory
  '<sil>[f :call maps#nextFile(0)<cr>', -- edit previous file in directory

  { '<l>f', function() require'fzf-lua'.files() end }, -- browse ./**
  '<l>F <cmd>History<cr>', -- browse oldfiles
  { '<ll>f', function() require'fzf-lua'.files() end }, -- browse %:p:h/**
  '<ll>F :Files %:p:h<c-z>', -- browse %:p:h/** but wait for user
  '<l>b <cmd>Buffers<cr>', -- switch buffers
  -- <l>sb :BLines<cr>', desc = 'find pattern in current buffer
  -- <l>sB :Lines<cr>', desc = 'find pattern in buffers
  -- <l>S :Rg ', desc = 'find pattern in files
  -- <l>: <cmd>History :<cr>
  -- <l>/ <cmd>History /<cr>
  '<l>cd :cd %:p:h<c-z>', -- cd %:p:h; wait
  '<l>g :Git ',

  -- config {{{1

  -- 'edit files in config'
  {
    '<ll>c', function()
      require'telescope.builtin'.find_files{
        cwd = vim.fn.stdpath'config'
      }
    end
  },

  -- 'edit files in config'
  {
    '<ll><ll>c', function()
      require'fzf-lua'.files{
        cwd = vim.fn.stdpath'config'
      }
    end
  },


  -- 'reload config'
  {
    '<ll>C', function()
      local dn = vim.fn.stdpath'config'..'/plugin/'
      local fd  = vim.uv.fs_opendir(dn, nil, 10)
      local fs = vim.uv.fs_readdir(fd)
      local files = {}
      while fs do
        for _,f in ipairs(fs) do
          if f.type == 'file' then
            local cmd = nil
            if f.name:match'.lua$' then -- lua script
              cmd = 'luafile'
            elseif f.name:match'.vim$' then -- vim script
              cmd = 'source'
            end
            if cmd then
              files[#files+1] = f.name
              vim.api.nvim_cmd({ cmd=cmd, args={dn..f.name} }, {})
            end
          end
        end
        fs = vim.uv.fs_readdir(fd)
      end
      vim.uv.fs_closedir(fd)
      print(vim.inspect( files ))
      print(string.format('Reloaded plugin/{%s}', table.concat(files, ',')))
    end
  },

  -- spell {{{1

  -- Quickly fix spelling errors (don't forget to :setl spell)
  -- Note: CTRL-S may conflict with "flow control" in some terminals

  ':i:   <c-s> <esc>[s1z=gi', -- quickly fix prev spell error in insert mode
  '<sil> <c-s>h [s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', -- fix prev spell error (repeatable)
  '<sil> <c-s>l ]s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', -- fix next spell error (repeatable)

  -- spell gooding (repeatable)
  [[<c-s>gh [Szg``:sil! call repeat#set("\<c-s>gh")<cr>]],
  [[<c-s>gl ]Szg``:sil! call repeat#set("\<c-s>gl")<cr>]],
  [[<c-s>Gh [SzG``:sil! call repeat#set("\<c-s>Gh")<cr>]],
  [[<c-s>Gl ]SzG``:sil! call repeat#set("\<c-s>Gl")<cr>]],

  -- cmdline {{{1
  ':c: <m-b> <s-left>',  -- better than <s-left>
  ':c: <m-f> <s-right>', -- better than <s-right>
  ':c: <m-h> <left>',    -- better than left
  ':c: <m-l> <right>',   -- better than right
  ':c: <m-k> <up>',      -- better than up
  ':c: <m-j> <down>',    -- better than down
  ':c: <m-a> <c-b>',     -- mirror <c-b>
  ':c: <m-e> <c-e>',     -- mirror <c-e>

  -- snap {{{1
  ':i: <m-p> <plug>(snapSimple)',         -- insert placeholder
  ':i: <m-P> <plug>(snapText)',           -- insert reminder
  ':inxso: <m-o> <plug>(snapNext)',       -- snap to next placeholder
  ':inxs:  <m-O> <plug>(snapRepeatNext)', -- repeat last snap on next placeholder
  ':inxso: <m-i> <plug>(snapPrev)',       -- snap to previous placeholder
  ':inxs:  <m-I> <plug>(snapRepeatPrev)', -- repeat last snap on previous placeholder
}

-- luasnip {{{1

local ok, ls = pcall(require, 'luasnip')
if ok then
  local e_,e,j_,j,ca_,cc = ls.expandable, ls.expand, ls.jumpable, ls.jump, ls.choice_active, ls.change_choice
  mapall{
    { ':is:  <m-space>', function() if e_() then e() end end }, -- 'expand luasnippet'
    { ':isn: <m-h>', function() if j_(-1) then j(-1) end end }, -- 'jump to previous luasnip node'
    { ':isn: <m-l>', function() if j_(1) then j(1) end end }, -- 'jump to next luasnip node' }
    { ':is: <m-j>', function() if ca_() then cc(1) end end }, -- 'cycle forward though luasnip node choices'
    { ':is: <m-k>', function() if ca_() then cc(-1) end end }, -- 'cycle backward though luasnip node choices'
  }
end
