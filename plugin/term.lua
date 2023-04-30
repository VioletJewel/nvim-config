-- Author: Violet
-- Last Change: 18 January 2023

local map = require'utils'.map
local au = require'utils'.buildaugroup('VioletTerm')
local cmd = vim.api.nvim_create_user_command

-- Note: do not mess with or interchange vim.cmd'insert' with nvim_feedkeys()
--       or vice versa,
--       and also do not mess with nvim_feedkeys() modes
--       ... unless you want neovim to lock up in tmux

-- treat term <c-w> like vim: allow <c-w>:, window navigation, etc
map{ '<c-w>', function()
  local wid = vim.api.nvim_get_current_win()
  local count = {}
  local ch = vim.fn.getcharstr()
  if ch ~= '0' then
    while ch:match('^%d$') do
      count[#count+1] = ch
      ch = vim.fn.getcharstr()
    end
  end
  count = table.concat(count, '')
  if ch == 'g' then
    ch = ch..vim.fn.getcharstr()
  end
  local keys
  if ch == 'N' then
    keys = vim.api.nvim_replace_termcodes('<c-bslash><c-n>', true, true, true)
    return vim.api.nvim_feedkeys(keys, 'n', false)
  end
  keys = vim.api.nvim_replace_termcodes('<c-bslash><c-n>'..count..'<c-w>'..ch, true, true, true)
  vim.api.nvim_feedkeys(keys, ch == 'N' and 'n' or 'x!', false)
  if vim.api.nvim_get_current_win() == wid then
    vim.api.nvim_feedkeys('i', 'nx!', false)
  else
    vim.api.nvim_buf_set_var(vim.api.nvim_win_get_buf(wid), '_term_ins_', true)
  end
end, modes='t' }

-- re-enter insert mode when coming back to a terminal when it was left with <c-w> map above
au{ 'BufWinEnter,WinEnter,CmdlineLeave', function()
    if vim.o.buftype == 'terminal' and vim.b._term_ins_ then
      vim.cmd'startinsert'
      vim.b._term_ins_ = nil
    end
  end }

-- split terminal command(s)
cmd('Sterminal', '<mods> split | terminal <args>', { nargs='*' })
cmd('STerminal', '<mods> split | terminal <args>', { nargs='*' })

-- :term and :vterm hacks to open terminals in splits (:ter/:terminal still work "normally")
vim.cmd[[ cabbrev <expr> term getcmdtype() is ':' && getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term' ]]
vim.cmd[[ cabbrev <expr> vterm getcmdtype() is ':' && getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm' ]]

-- prettify statusline; auto-start insert
au{ 'TermOpen', function()
    if vim.bo.buflisted then
      local shortname = vim.api.nvim_buf_get_name(0):gsub('%S*:', '')
      if shortname == vim.o.shell then
        shortname = shortname:gsub('.*/', '')
      end
      vim.b.shortname = shortname
      vim.wo.statusline = '%{b:shortname}%=[terminal]'
      vim.cmd'startinsert'
    end
  end }

-- auto-close response when terminal closed (only if $?=0 and prgm=&shell)
au{ 'TermClose', function()
    if vim.o.shell == vim.api.nvim_buf_get_name(0):gsub('%S*:','') and vim.v.event.status == 0 then
      vim.fn.feedkeys('q', 'nt')
    end
  end }

