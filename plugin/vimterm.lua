local augroup = vim.api.nvim_create_augroup('VimTerm', {})
local au = vim.api.nvim_create_autocmd
local fk = vim.api.nvim_feedkeys

local function keycode(s)
  return vim.api.nvim_replace_termcodes(s, true, false, true)
end

local CB = keycode'<C-Bslash>'
local CBCn = keycode'<C-Bslash><C-n>'
local CBCo = keycode'<C-Bslash><C-o>'
local Cn = keycode'<C-n>'
local Cw = keycode'<C-w>'
local Ct = keycode'<C-t>'
local Cb = keycode'<C-b>'
local Ck = keycode'<C-k>'
local Cj = keycode'<C-j>'
local Ch = keycode'<C-h>'
local Cl = keycode'<C-l>'
local Up = keycode'<Up>'
local Down = keycode'<Down>'
local Left = keycode'<Left>'
local Right = keycode'<Right>'

local opts = {
  autostartTermMode = true,
  autocloseTerm = true,
  autosetTermTitle = true,
  termwinkey = '<C-w>',
  abbrevHack = true,
}

local inhibitWinTermModeSet = false

au('TermOpen', {
  group = augroup,
  callback = function(ev)
    if not vim.bo[ev.buf].buflisted then return end

    local isDefaultShell = false
    local name = ev.file:gsub('^[^:]+:', ''):gsub('^([^:]+):', '')
    if name == vim.o.shell then
      name = name:gsub('.*/', '')
      isDefaultShell = true
    end
    name = name .. ':' .. vim.b[ev.buf].terminal_job_pid
    vim.b[ev.buf].vimterm_title = name
    if opts.autosetTermTitle then
      vim.b[ev.buf].term_title = name
      vim.api.nvim_buf_set_name(ev.buf, name)
    end

    if opts.autostartTermMode and vim.api.nvim_get_mode().mode ~= 't' then
      vim.cmd.startinsert()
    end

    vim.keymap.set('t', opts.termwinkey, function()
      local tcount = {}
      local ch = vim.fn.getcharstr()
      local cbuf = vim.api.nvim_get_current_buf()
      local cwin = vim.api.nvim_get_current_win()
      local nwin = cwin

      if ch ~= '0' then           -- {count}
        while ch:match('^%d$') do -- {count} /[1-9][0-9]*/
          tcount[#tcount + 1] = ch
          ch = vim.fn.getcharstr()
        end
      end
      local scount = table.concat(tcount, '')

      if ch == '.' then                 -- Literal [count] Ctrl-w
        return fk(string.rep(opts.termwinkey, tonumber(scount) or 1), 'nt', false)
      elseif ch == CB then              -- Literal C-bslash
        return fk(string.rep(CB, tonumber(scount) or 1), 'nt', false)
      elseif ch == 'g' then             -- Tab Page Navigation: <C-w>gt, <C-w>gT
        ch = ch .. vim.fn.getcharstr()
      elseif ch == 'N' or ch == Cn then -- Normal Mode: <C-w>N
        return vim.cmd.stopinsert()
      elseif ch == '"' then             -- Register Paste: <C-w>"
        vim.cmd.stopinsert { mods = { noautocmd = true } }
        ch = vim.fn.escape(vim.fn.getcharstr())
        fk(scount .. '"' .. ch .. 'p', 'nt', false)
        vim.cmd.stopinsert { mods = { noautocmd = true } }
        return
      end

      -- local nbuf = cbuf
      if ch == 'w' or ch == Cw then -- <C-w>w
        local wins = vim.api.nvim_tabpage_list_wins(0)
        local cwnum = vim.api.nvim_win_get_number(cwin)
        nwin = scount == '' and (cwnum % #wins + 1) or math.min(#wins, tonumber(scount) or 1)
        if cwin == nwin then return end
        -- local nwnum = scount == '' and (cwnr % #ws + 1) or math.min(#ws, tonumber(scount) or 1)
        -- nbuf = vim.api.nvim_win_get_buf(ws[nwnum])
      elseif ch == 'W' then -- <C-w>W
        local wins = vim.api.nvim_tabpage_list_wins(0)
        local cwnum = vim.api.nvim_win_get_number(cwin)
        nwin = scount == '' and ((cwnum - 1) % #ws + 1) or math.min(#wins, tonumber(scount) or 1)
        if cwin == nwin then return end
        -- local ws = vim.api.nvim_list_wins()
        -- local cwnr = vim.api.nvim_win_get_number(cwin)
        -- local nwnum = scount == '' and ((cwnr - 1) % #ws + 1) or math.min(#ws, tonumber(scount) or 1)
        -- nbuf = vim.api.nvim_win_get_buf(ws[nwnum])
      elseif ch == 't' or ch == Ct then -- <C-w>t
        nwin = vim.api.nvim_tabpage_list_wins(0)[1]
        if cwin == nwin then return end
        -- nbuf = vim.api.nvim_win_get_buf(vim.api.nvim_list_wins()[1])
      elseif ch == 'b' or ch == Cb then -- <C-w>b
        local wins = vim.api.nvim_tabpage_list_wins(0)
        nwin = wins[#wins]
        if cwin == nwin then return end
        -- nbuf = vim.api.nvim_win_get_buf(vim.api.nvim_list_wins()[1])
        -- local ws = vim.api.nvim_list_wins()
        -- nbuf = vim.api.nvim_win_get_buf(ws[#ws])
      elseif ch == 'gt' then -- <C-w>gt
        local tabs = vim.api.nvim_list_tabpages()
        if scount == '' then
          local ntabnum = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage()) % #tabs + 1
          nwin = vim.api.nvim_tabpage_get_wins(tabs[ntabnum])
          -- nbuf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabs[ntabnum]))
        else
          local ntabnum = tonumber(scount)
          if ntabnum <= #tabs then
            nwin = vim.api.nvim_tabpage_get_win(tabs[ntabnum])
            -- nbuf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabs[ntnr]))
          end
        end
      elseif ch == 'gT' then -- <C-w>gT (note: different than gt: {count} = cyclical)
        local tabs = vim.api.nvim_list_tabpages()
        local ctabnum = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
        local ntabnum = ((ctabnum - (tonumber(scount) or 1)) % #tabs + 1)
        nwin = vim.api.nvim_tabpage_get_win(tabs[ntabnum])
        -- nbuf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabs[ntabnum]))
      elseif ch == 'k' or ch == Ck or ch == Up then    -- <C-w>k
        nwin = vim.fn.winnr 'k'
        if cwin == nwin then return end
        -- nbuf = vim.fn.winbufnr(vim.fn.winnr 'k')
      elseif ch == 'j' or ch == Cj or ch == Down then  -- <C-w>j
        nwin = vim.fn.winnr 'j'
        if cwin == nwin then return end
        -- nbuf = vim.fn.winbufnr(vim.fn.winnr 'j')
      elseif ch == 'h' or ch == Ch or ch == Left then  -- <C-w>h
        nwin = vim.fn.winnr 'h'
        if cwin == nwin then return end
        -- nbuf = vim.fn.winbufnr(vim.fn.winnr 'h')
      elseif ch == 'l' or ch == Cl or ch == Right then -- <C-w>l
        nwin = vim.fn.winnr 'l'
        if cwin == nwin then return end
        -- nbuf = vim.fn.winbufnr(vim.fn.winnr 'l')
      end

      inhibitWinTermModeSet = true
      if cwin == nwin then
        fk(CBCo .. scount .. Cw .. ch, 'ni', false)
      else
        local nbuf = vim.api.nvim_win_get_buf(nwin)
        if vim.bo[nbuf].buftype == 'terminal' and vim.w[nwin]._term_termmode_ then
          fk(CBCn .. scount .. Cw .. ch .. 'i', 'nix!', false)
        else
          fk(CBCn .. scount .. Cw .. ch, 'nix', false)
        end
        local i = vim.bo[nbuf].buftype == 'terminal' and vim.w[nwin]._term_termmode_ 
        fk(CBCn .. scount .. Cw .. ch, 'ni', false)
        -- local nbuf = vim.api.nvim_win_get_buf(nwin)
        -- if vim.bo[nbuf].buftype == 'terminal' then
        -- if vim.bo.buftype == 'terminal' then
        --   -- inhibitWinTermModeSet = true
        --   vim.cmd[vim.w._term_termmode_ and 'startinsert' or 'stopinsert']()
        --   -- vim.cmd[vim.w._term_termmode_ and 'startinsert' or 'stopinsert'] { mods = { noautocmd = true } }
        --   -- vim.cmd[vim.w[nwin]._term_termmode_ and 'startinsert' or 'stopinsert'] { mods = { noautocmd = true } }
        -- end
      end

      -- local nbuf = vim.api.nvim_win_get_buf(nwin)
      -- if vim.bo[nbuf].buftype == 'terminal' then
      --   vim.cmd[vim.w[nwin]._term_termmode_ and 'startinsert' or 'stopinsert'] { mods = { noautocmd = true } }
      -- end
      -- -- local p = vim.bo[nbuf].buftype == 'terminal' and CBCo of ''
      -- local m = cbuf == nbuf and 'ni' or 'nx'
      -- fk(p .. scount .. Cw .. ch, m, false)
      -- -- vim.w[winid]._term_termmode_ = cbuf ~= nbuf

    end, {
      buffer = ev.buf,
    })

    if isDefaultShell and opts.autocloseTerm then
      au('TermClose', {
        buffer = ev.buf,
        callback = function()
          local code = vim.v.event.status
          if code == 0 or code == 130 then
            fk(' ', 'ntx', false)
          end
        end
      })
    end

    au({ 'TermLeave', 'TermEnter' }, {
      buffer = ev.buf,
      callback = function(evt)
        if inhibitWinTermModeSet then
          inhibitWinTermModeSet = false
          return
        end
        vim.w[vim.api.nvim_get_current_win()]._term_termmode_ = evt.event == 'TermEnter'
        print('set winTermMode', vim.w[vim.api.nvim_get_current_win()]._term_termmode_, vim.api.nvim_get_current_win())
      end
    })

    au({ 'BufWinEnter', 'WinEnter', 'CmdlineLeave' }, {
      buffer = ev.buf,
      callback = function()
        local winid = vim.api.nvim_get_current_win()
        local mode = vim.api.nvim_get_mode().mode
        if vim.w[winid]._term_termmode_ then
          vim.cmd.startinsert()
          vim.w[winid]._term_termmode_ = true
        elseif mode == 't' then
          vim.cmd.stopinsert()
          vim.w[winid]._term_termmode_ = false
        end
      end
    })
  end
})

-- :Sterminal for split terminal.
vim.api.nvim_create_user_command('Sterminal', '<mods> split | terminal <args>', { nargs='*' })

-- :STerminal for split terminal (for convenience/accidents).
vim.api.nvim_create_user_command('STerminal', '<mods> split | terminal <args>', { nargs='*' })

if opts.abbrevHack then
  -- (hack) expand :term to :Sterm.
  vim.keymap.set('ca', 'term',
    "getcmdtype() is ':' && getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term'",
    { expr=true })

  -- (hack) expand :vterm to :vert Sterm.
  vim.keymap.set('ca', 'vterm',
    "getcmdtype() is ':' && getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm'",
    { expr=true })
end
