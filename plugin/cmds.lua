local cmd = vim.api.nvim_create_user_command
local opts

local docsdir
do
  local fh = io.popen 'xdg-user-dir DOCUMENTS'
  if fh then
    docsdir = fh:read()
    fh:close()
  end
end

cmd('Journal', function(day)
  -- TODO: support day
  vim.cmd.edit(vim.fs.joinpath(docsdir, 'journal', os.date '%Y-%m-%d.md'))
end, {
  nargs = 0
})

local cfg = vim.fn.stdpath 'config'
if type(cfg) == 'table' then cfg = cfg[1] end

local snipdir = vim.fn.stdpath 'config' .. '/snippets/'

local snipCompl = function(lead, _, _) -->
  ---@diagnostic disable-next-line: param-type-mismatch
  local fd = vim.uv.fs_opendir(snipdir, nil, 10)
  local fs = vim.uv.fs_readdir(fd)
  local snipfiles = {}
  local m = lead .. '.*%.lua$'
  while fs do
    for _, f in ipairs(fs) do
      if f.type == 'file' and f.name:match(m) then
        snipfiles[#snipfiles + 1] = f.name:sub(1, -5)
      end
    end
    fs = vim.uv.fs_readdir(fd)
  end
  vim.uv.fs_closedir(fd)
  return snipfiles
end                         --<

cmd('Snipedit', function(c) -->
  local f = snipdir .. (c.args == '' and vim.o.filetype or c.args) .. '.lua'
  vim.cmd.edit(f)
end, { nargs = '?', complete = snipCompl }) --<

cmd('Snip', function(c)                     -->
  local f = snipdir .. (c.args == '' and vim.o.filetype or c.args) .. '.lua'
  vim.cmd {
    cmd = 'new',
    args = { f },
    mods = c.smods,
  }
end, { nargs = '?', complete = snipCompl }) --<

opts = { bang = true, bar = true, nargs = '?' }
cmd('Q', 'q<bang> <args>', opts)
cmd('QA', 'qa<bang> <args>', opts)
cmd('Qa', 'qa<bang> <args>', opts)
cmd('WQ', 'wq<bang> <args>', opts)
cmd('Wq', 'wq<bang> <args>', opts)
cmd('WQA', 'wqa<bang> <args>', opts)
cmd('WQa', 'wqa<bang> <args>', opts)
cmd('Wqa', 'wqa<bang> <args>', opts)

-- :{arg,buf,win}do without mucking syntax or changing buffers
opts = { nargs = '+' }

cmd('Argdo', function(a) -->
  local bufnr = vim.api.nvim_get_current_buf()
  local ei = vim.o.eventignore
  vim.cmd('argdo ' .. a.args, { output = false })
  vim.o.eventignore = ei
  vim.api.nvim_set_current_buf(bufnr)
end, opts)               --<

cmd('Bufdo', function(a) -->
  local bufnr = vim.api.nvim_get_current_buf()
  local ei = vim.o.eventignore
  vim.cmd('bufdo ' .. a.args, { output = false })
  vim.o.eventignore = ei
  vim.api.nvim_set_current_buf(bufnr)
end, opts)               --<

cmd('Windo', function(a) -->
  local winnr = vim.api.nvim_get_current_win()
  local ei = vim.o.eventignore
  vim.cmd('windo ' .. a.args, { output = false })
  vim.o.eventignore = ei
  vim.api.nvim_set_current_win(winnr)
end, opts)                                         --<

local function filelistGrep(search, list, vimgrep) -->
  vim.fn.setqflist({})
  local c = vimgrep and 'vimgrepadd' or 'grepadd'
  local s = vim.fn.escape(search, '"')
  print('Searching in ' .. (#list) .. ' files')
  for _, bufnr in ipairs(list) do
    local buf = vim.fn.fnameescape(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p'))
    vim.cmd[c] { args = { '"' .. s .. '"', buf }, bang = true, mods = { silent = true } }
  end
  vim.cmd.cwindow { mods = { split = 'botright' } }
  vim.cmd.redraw { bang = true }
end                         --<

local function getBuffers() -->
  local bufs = {}
  for b = 1, vim.fn.bufnr '$' do
    if vim.fn.buflisted(b) and vim.bo[b].buftype == '' then
      table.insert(bufs, b)
    end
  end
  return bufs
end --<

-- :{Arg,Buf}grep

opts = { nargs = 1, bar = true }

cmd('ArgGrep', function(a) filelistGrep(a.args, vim.fn.argv(), false) end, opts)
cmd('ArgVimGrep', function(a) filelistGrep(a.args, vim.fn.argv(), true) end, opts)
cmd('BufGrep', function(a) filelistGrep(a.args, getBuffers(), false) end, opts)
cmd('BufVimGrep', function(a) filelistGrep(a.args, getBuffers(), true) end, opts)


opts = { range = true, nargs = 1, complete = 'command' }
-- :redir => out | sil <args> | redir end | sil put= out | sil 1d
cmd('Put', function(a) -->
  local out = vim.split(vim.api.nvim_exec2(a.args, { output = true }).output, '\n')
  vim.api.nvim_put(out, 'l', true, false)
end, opts) --<

-- split (below) :redir => out | sil <args> | redir end | sil put= out | sil 1d
cmd('Sput', function(a) -->
  local out = vim.split(vim.api.nvim_exec2(a.args, { output = true }).output, '\n')
  vim.api.nvim_open_win(vim.api.nvim_create_buf(true, true), true, { split = 'below' })
  vim.api.nvim_put(out, 'l', true, false)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.api.nvim_del_current_line()
end, opts) --<

-- floating :redir => out | sil <args> | redir end | sil put= out | sil 1d
cmd('Fput', function(a) -->
  local out = vim.split(vim.api.nvim_exec2(a.args, { output = true }).output, '\n')
  local x = math.ceil(.1 * vim.o.columns)
  local y = math.ceil(.1 * vim.o.lines)
  local w = math.floor(.8 * vim.o.columns)
  local h = math.floor(.8 * vim.o.lines)
  vim.api.nvim_open_win(vim.api.nvim_create_buf(true, true), true, {
    relative = 'editor',
    col = x,
    row = y,
    width = w,
    height = h
  })
  vim.api.nvim_put(out, 'l', true, false)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.api.nvim_del_current_line()
end, opts) --<


-- :help :DiffOrig
opts = { bar = true, nargs = '?' }
cmd('DiffOrig', 'vnew|set bt=nofile|r ++edit #|0d_|difft|winc p|difft', opts)

-- clear quickfix
opts = { nargs = 0 }
cmd('Cclear', 'call setqflist([], "r")', opts)
