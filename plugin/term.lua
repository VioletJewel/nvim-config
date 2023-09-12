-- Author: Violet
-- Last Change: 12 September 2023

-- Overview: basically remove barriers for speedier terminal use.
-- tl;dr:
--  :Sterminal => open :terminal in horizontal split
--  :vertical Sterminal => open :term in vertical split
--  :term => :Sterm (hack using :cabbrev - only "term" at beg of cmdline)
--  :vterm => :vert Sterm (hack using :cabbrev)
--  t_CTRL-W acts like vim
--    - <c-w>: => issue command
--    - <c-w>[count]"{reg} => insert register
--    - <c-w>[count]gt <c-w>[count]gT => tab page nav
--    - win nav/resize => eg, <c-w>h <c-w>10_ <c-w>= etc
--    - <c-w>. => literal <c-w>
--  auto-insert-mode when terminal opened
--  auto close terminal if no error and shell is user's &shell
--  nicer buffer name for :term &statusline

local map = require'utils'.map
local au = require'utils'.augroup('VioletTerm')
local cmd = vim.api.nvim_create_user_command

-- Note: do not change/switch startinsert w nvim_feedkeys() or vice versa,
--       and also do not mess with nvim_feedkeys() modes
--       ... unless you want neovim to lock up in tmux ...
--       and finally be sure to use w: and not b:
--       tl;dr if you change anything, beware that neovim will probably freeze 

local N = vim.api.nvim_replace_termcodes('<c-bslash><c-n>', true, true, true)

-- treat term <c-w> like vim
map{ ':t: <c-w>', function()
  local wid = vim.api.nvim_get_current_win()
  local tcount = {}
  local ch = vim.fn.getcharstr()
  if ch == '.' then -- t_ctrl-w . => literal ctrl-w
    local ctrlw = vim.api.nvim_replace_termcodes('<c-w>', true, true, true)
    return vim.api.nvim_feedkeys(ctrlw, 'nt', false)
  end
  if ch ~= '0' then
    while ch:match('^%d$') do -- count: /[1-9][0-9]*/
      tcount[#tcount+1] = ch
      ch = vim.fn.getcharstr()
    end
  end
  count = table.concat(tcount, '')
  if ch == 'g' then -- t_ctrl-w gt, t_ctrl-w gT => :tabnext, :tabprev
    ch = ch..vim.fn.getcharstr()
  end
  local keys
  if ch == 'N' then -- t_ctrl-w N => ctrl-bslash ctrl-n
    return vim.api.nvim_feedkeys(N, 'n', false)
  end
  if ch == '"' then -- t_ctrl-w [count] " {reg} => insert {reg} [count] times
    ch = vim.fn.getcharstr()
    return vim.api.nvim_feedkeys(N..count..'"'..ch..'pi', 'nt', false)
  end
  vim.api.nvim_win_set_var(wid, '_term_ins_', true)
  keys = vim.api.nvim_replace_termcodes('<c-bslash><c-n>'..count..'<c-w>'..ch, true, true, true)
  vim.api.nvim_feedkeys(keys, '', false)
end }

-- re-enter insert mode when coming back to a terminal when it was left with <c-w> map above
au{ 'BufWinEnter,WinEnter,CmdlineLeave',
  callback = function()
    if vim.o.buftype == 'terminal' and vim.w._term_ins_ then
      if vim.fn.mode(1) == 'nt' then
        vim.cmd'startinsert'
        vim.w._term_ins_ = false
      end
    end
  end
}

cmd('Sterminal', '<mods> split | terminal <args>', { nargs='*' })
cmd('STerminal', '<mods> split | terminal <args>', { nargs='*' })

vim.cmd[[ cabbrev <expr> term getcmdtype() is ':' && getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term' ]]
vim.cmd[[ cabbrev <expr> vterm getcmdtype() is ':' && getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

-- prettify statusline; auto-start insert
au{ 'TermOpen',
  callback = function()
    if vim.bo.buflisted then
      local shortname = vim.api.nvim_buf_get_name(0):gsub('%S*:', '')
      if shortname == vim.o.shell then
        shortname = shortname:gsub('.*/', '')
      end
      vim.b.shortname = shortname
      vim.wo.statusline = '%{b:shortname}%=[terminal]'
      if vim.fn.mode(1) ~= 't' then
        vim.cmd'startinsert'
      end
    end
  end
}

au{ 'TermClose',
  callback = function()
    if vim.o.shell == vim.api.nvim_buf_get_name(0):gsub('%S*:','')
      and vim.v.event.status == 0 then
      vim.fn.feedkeys(' ', 'nt')
    end
  end
}

