-- Author: Violet
-- Last Change: 19 July 2023

-- setup {{{1


local map = require'utils'.map
local au = require'utils'.augroup('VioletMaps')
local desc


-- main {{{1


map{ '<L>',
  desc='minimize mapleader side effects: <leader> => <nop>' }


map{ '<m-w>', '<cmd>sil up<cr>', modes='nix',
  'quietly update file' }

map{ '<m-W>', '<cmd>sil noa up<cr>', modes='nix',
  'quietly update without autocmds' }

map{ '<m-e>', '<cmd>sil wa<cr>', modes='nix',
  'quietly update all unchanged buffers' }

map{ '<m-e>', '<cmd>sil noa wa<cr>', modes='nix',
  'quietly update all unchanged buffers w/o autocmds' }


map{ '<LL>q', '<cmd>qa<cr>',
  'quit unless unsaved changes' }


map{ '<c-l>', "<cmd>noh|dif|redr!|echon''<cr>",
  ':nohlsearch, :diffupdate, :redraw! all in one' }

map{ '<L><c-l>', '<cmd>syn sync fromstart<cr>',
  'sync syntax from beginning of file' }


map{ '<c-p>', "{last->stridx(':/?',last) is -1?':':last}(get(g:,'_cmdtype_last_',':'))..'<c-p>'", expr=true,
  'opens last command or search' }

au( 'CmdlineEnter', {
  callback = function()
    vim.g._cmdtype_last_ = vim.v.event.cmdtype
  end
})

map{ '<c-p>', ":<c-u>'<,'><up>", modes='x',
  "open last command operating on visual selection" }


map{ 'zO', "foldclosed('.') is -1 ? 'zczO' : 'zO'", expr=true,
  'same as zO but if fold already open, close first' }


map{ '<L>;', "(getline('.')=~#';\\s*$'?'g_x':'g_a;<esc>').virtcol('.').'|'", expr=true, silent=true,
  'toggle ";" at end of line' }


map{ '<m-M>', '<cmd>sil Make<cr>',
  'quick :Make' }

map{ '<m-L>', '<cmd>sil Lmake<cr>',
  'quick :Lmake' }


map{ '<L>p', '<cmd>call synstack#echo()<cr>',
  'print highlight groups' }

map{ '<L>p', 'synstack#vExprPrint()', modes='x', expr=true,
  "print stats visual selection (similar to 'showcmd')" }


map{ 'w', '<cmd>call maps#o_word(0)<cr>', modes='o',
  'fix cw/dw inconsistency' }

map{ 'W', '<cmd>call maps#o_word(1)<cr>', modes='o',
  'fix cW/dW inconsistency' }


map{ '<m-j>', 'zczjzo', silent=true,
  'move to next fold' }

map{ '<m-k>', 'zczkzo', silent=true,
  'move to prev fold' }

map{ '<c-r><c-u>', function()
    local inp = vim.fn.input':Repeat/'
    local sepPos = inp:find'/'
    local amt = inp:sub(1, sepPos-1)
    local str = inp:sub(sepPos+1)
    return ('<c-r>=repeat(%s,%s)<cr>'):format(vim.fn.string(str), amt)
  end, modes='i', expr=true, silent=true,
  'repeat string in insert mode'}

-- search {{{1


map{ '*', "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<cr>",
  "* but respect capitalization; don't move cursor" }

map{ '#', "<cmd>let v:hlsearch=setreg('/', '\\<'..expand('<cword>')..'\\>\\C')+1<bar>call search('', 'bc')<cr>",
  "# but respect capitalization; move cursor to beg of word" }

map{ 'g*', "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<cr>",
  "g* without \\< and \\>" }

map{ 'g#', "<cmd>let v:hlsearch=setreg('/', expand('<cword>')..'\\C')+1<bar>call search('', 'bc')<cr>",
  "g# without \\< and \\>" }


map{ '*', '<esc>*gv', modes='x',
  'use * in visual mode' }

map{ '#', '<esc>#gv', modes='x',
  'use # in visual mode' }

map{ 'g*', '<esc>g*gv', modes='x',
  'use g* in visual mode' }

map{ 'g#', '<esc>g#gv', modes='x',
  'use g# in visual mode' }


--    eg: c*Replacement<esc>.. to replace <cword> with 'Replacement' and repeat twice

map{ '*', 'maps#stargn(1)', expr=true, silent=true, modes='o', "faster *N{op}gn" }
map{ '#', 'maps#stargn(1)', expr=true, silent=true, modes='o', "faster #N{op}gn" }
map{ 'g*', 'maps#stargn(0)', expr=true, silent=true, modes='o',  "faster g*N{op}gn" }
map{ 'g#', 'maps#stargn(0)', expr=true, silent=true, modes='o',  "faster g#N{op}gn" }


map{ '<L>#', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gvo', modes='x',
  'search backward for literal visual selection' }

map{ '<L>*', ':<c-u>let v:hlsearch=maps#visSearch()+1<cr>gv', modes='x',
  'search forward for literal visual selection' }


map{ 'n', modes='nxo', function()
      vim.v.searchforward = 1
      vim.api.nvim_feedkeys('n', 'ntx', false)
      if vim.fn.foldclosed('.') >= 0 then
        vim.cmd'silent! foldopen!'
      end
    end,
  'always search forwards' }

map{ 'N', modes='nxo', function()
      vim.v.searchforward = 1
      vim.api.nvim_feedkeys('N', 'ntx', false)
      if vim.fn.foldclosed('.') >= 0 then
        vim.cmd'silent! foldopen!'
      end
    end,
  'always search backwards' }


map{ '<c-t>', "<c-t><c-r>=execute('sil! foldo!')[-1]<cr>", modes='c' }

map{ '<c-g>', "<c-g><c-r>=execute('sil! foldo!')[-1]<cr>", modes='c' }


-- quick {{{1


map{ '[b', ":<c-u>execute v:count.'bprevious'<cr>", silent=true,
  '[count] bprevious' }

map{ '[B', ":bfirst<cr>", silent=true,
  'bfirst' }

map{ ']b', ":<c-u>execute v:count.'bnext'<cr>", silent=true,
  '[count] bnext' }

map{ ']B', ":blast<cr>", silent=true,
  'blast' }


map{ '[a', ":<c-u>execute v:count.'previous'<cr>", silent=true,
  '[count] previous' }

map{ '[A', ":first<cr>", silent=true,
  'first' }

map{ ']a', ":<c-u>execute v:count.'next'<cr>", silent=true,
  '[count] next' }

map{ ']A', ":last<cr>", silent=true,
  'last' }


map{ '<L>ww', '<cmd>call maps#locToggle()<cr>', silent=true,
  'toggle local list' }

map{ '<L>wo', ':lopen<cr>', silent=true,
  'open local list' }

map{ '<L>wc', ':lclose<cr>', silent=true,
  'close local list' }


map{ '[w', ":<c-u>execute v:count.'lprevious'<cr>", silent=true,
  '[count] lprevious' }

map{ '[W', ':lfirst<cr>', silent=true,
  'lfirst' }


map{ ']w', ":<c-u>execute v:count.'lnext'<cr>", silent=true,
  '[count] lnext' }

map{ ']W', ":llast<cr>", silent=true,
  'llast' }


map{ '<L>qq', '<cmd>call maps#qfToggle()<cr>', silent=true,
  'toggle quickfix list' }

map{ '<L>qo', ':belowright copen<cr>', silent=true,
  'open quickfix list' }

map{ '<L>qc', ':cclose<cr>', silent=true,
  'close quickfix list' }


map{ '[q', ":<c-u>execute v:count.'cprevious'<cr>", silent=true,
  '[count] cprevious' }

map{ '[Q', ':cfirst<cr>', silent=true,
  'cfirst' }


map{ ']q', ":<c-u>execute v:count.'cnext'<cr>", silent=true,
  '[count] cnext' }

map{ ']Q', ':clast<cr>', silent=true,
  'clast' }


map{ '[e', ':<c-u>call maps#moveLine(0, v:count, 0)<cr>', silent=true,
  'move line up' }

map{ '[e', ':<c-u>call maps#moveLine(0, v:count, 1)<cr>', silent=true, modes='x',
  'move selection up' }


map{ ']e', ':<c-u>call maps#moveLine(1, v:count, 0)<cr>', silent=true,
  'move line down' }

map{ ']e', ':<c-u>call maps#moveLine(1, v:count, 1)<cr>', silent=true, modes='x',
  'move selection down' }


map{ '[g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'wb')<cr>", silent=true,
  'jump to next git marker' }

map{ ']g', ":call search('^\\%(<<<<<<<\\|=======\\|>>>>>>>\\)', 'w')<cr>", silent=true,
  'jump to previous git marker' }


map{ ']f', ':call maps#nextFile(1)<cr>', silent=true,
  'edit next file in directory' }

map{ '[f', ':call maps#nextFile(0)<cr>', silent=true,
  'edit previous file in directory' }


map{ '<L>f', ':Files<cr>',
  'browse ./**' }

map{ '<L>F', '<cmd>History<cr>',
  'browse oldfiles' }

map{ '<LL>f', function()
      require'fzf-lua'.files()
    end,
  'browse %:p:h/**' }


map{ '<LL>F', ':Files %:p:h<c-z>',
  'browse %:p:h/** but wait for user' }

map{ '<L>b', '<cmd>Buffers<cr>',
  'switch buffers' }

-- map{'<L>sb', ':BLines<cr>', 'find pattern in current buffer'}
-- map{'<L>sB', ':Lines<cr>', 'find pattern in buffers'}
-- map{'<L>S', ':Rg ', 'find pattern in files'}
-- map{'<L>:', '<cmd>History :<cr>'}
-- map{'<L>/', '<cmd>History /<cr>'}

map{ '<L>cd', ':cd %:p:h<c-z>',
  'cd %:p:h; wait' }

map{ '<L>g', ':Git '}


-- config {{{1


map{ '<LL>c', function()
      require'telescope.builtin'.find_files{
        cwd = vim.fn.stdpath'config'
      }
    end,
  'edit files in config' }

map{ '<LL><LL>c', function()
      require'fzf-lua'.files{
        cwd = vim.fn.stdpath'config'
      }
    end,
  'edit files in config' }


map{ '<LL>C', function()
      local dn = vim.fn.stdpath'config'..'/plugin/'
      local fd  = vim.loop.fs_opendir(dn, nil, 10)
      local fs = vim.loop.fs_readdir(fd)
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
        fs = vim.loop.fs_readdir(fd)
      end
      vim.loop.fs_closedir(fd)
      print(vim.inspect( files ))
      print(string.format('Reloaded plugin/{%s}', table.concat(files, ',')))
    end,
  'reload config' }


-- spell {{{1

-- Quickly fix spelling errors (don't forget to :setl spell)
-- Note: CTRL-S may conflict with "flow control" in some terminals


map{ '<c-s>', '<esc>[s1z=gi', modes='i',
  'quickly fix prev spell error in insert mode' }


map{ '<c-s>h', '[s1z=``:sil! call repeat#set("\\<c-s>h")<cr>', silent=true,
  'fix prev spell error (repeatable)' }

map{ '<c-s>l', ']s1z=``:sil! call repeat#set("\\<c-s>l")<cr>', silent=true,
  'fix next spell error (repeatable)' }


desc = 'spell gooding (repeatable)'

map{ '<c-s>gh', '[Szg``:sil! call repeat#set("\\<c-s>gh")<cr>',
  desc }

map{ '<c-s>gl', ']Szg``:sil! call repeat#set("\\<c-s>gl")<cr>',
  desc }

map{ '<c-s>Gh', '[SzG``:sil! call repeat#set("\\<c-s>Gh")<cr>',
  desc }

map{ '<c-s>Gl', ']SzG``:sil! call repeat#set("\\<c-s>Gl")<cr>',
  desc }


-- cmdline {{{1


map{ '<m-b>', '<s-left>', modes='c',
  'better than <s-left>' }

map{ '<m-f>', '<s-right>', modes='c',
  'better than <s-right>' }


map{ '<m-h>', '<left>', modes='c',
  'Better than left' }

map{ '<m-l>', '<right>', modes='c',
  'Better than right' }

map{ '<m-k>', '<up>', modes='c',
  'Better than up' }

map{ '<m-j>', '<down>', modes='c',
  'Better than down' }


map{ '<m-a>', '<c-b>', modes='c',
  'mirror <c-b>' }

map{ '<m-e>', '<c-e>', modes='c',
  'mirror <c-e>' }


-- snap {{{1


map{ '<m-p>', '<plug>(snapSimple)', modes='i',
  'insert placeholder' }

map{ '<m-P>', '<plug>(snapText)', modes='i',
  'insert reminder' }

map{ '<m-o>', '<plug>(snapNext)', modes='inxso',
  'snap to next placeholder' }

map{ '<m-O>', '<plug>(snapRepeatNext)', modes='inxs',
  'repeat last snap on next placeholder' }

map{ '<m-i>', '<plug>(snapPrev)', modes='inxso',
  'snap to previous placeholder' }

map{ '<m-I>', '<plug>(snapRepeatPrev)', modes='inxs',
  'repeat last snap on previous placeholder' }


-- luasnip {{{1


local ok, ls = pcall(require, 'luasnip')
if ok then

  map{ '<m-j>', function()
        if ls.expandable() then
          ls.expand()
        end
      end, modes='is',
    'expand luasnippet' }

  map{ '<m-h>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, modes='isn',
  'jump to previous luasnip node' }

  map{ '<m-l>', function()
      if ls.jumpable(1) then
        ls.jump(1)
      end
    end, modes='isn',
  'jump to next luasnip node' }

  map{ '<m-k>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, modes='is',
  'cycle forward though luasnip node choices' }

  map{ '<m-K>', function()
    if ls.choice_active() then
      ls.change_choice(-1)
    end
  end, modes='is',
  'cycle backward though luasnip node choices' }

end

