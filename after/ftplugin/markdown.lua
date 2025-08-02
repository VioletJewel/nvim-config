local ft = require 'utils.ftplugin'

ft.setOpt('concealcursor', '')
ft.setOpt('conceallevel', 0)

ft.appendOpt('formatoptions', '2')
ft.appendOpt('formatoptions', 'n')

ft.setOpt('foldlevel', 0)

ft.setOpt('softtabstop', 2)
ft.setOpt('tabstop', 2)
ft.setOpt('shiftwidth', 2)

local todo_items = ' x/-'

ft.addMap('n', '<Tab>', function() -->
  local lr = vim.go.lazyredraw
  vim.go.lazyredraw = true
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find('^%s*- %[[' .. todo_items .. ']%]')
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    local char_ind = todo_ind % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
  vim.go.lazyredraw = lr
  vim.cmd.redraw()
end, {
  silent = true,
  desc = 'Cycle through markdown things!'
}) --<

ft.addMap('n', '<S-Tab>', function() -->
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find('^%s*- %[[' .. todo_items .. ']%]')
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    local char_ind = (todo_ind - 2) % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
end, {
  silent = true,
  desc = 'Cycle backwards through markdown things!'
}) --<

local function getLink()
  local node = require 'nvim-treesitter.ts_utils'.get_node_at_cursor()
  if not node then return end
  local link, linkType
  if node:type() == 'inline_link' then
    -- [desc](link)
    -- ^    ^^    ^
    link = node:child(4)
    linkType = 'inline_link'
  elseif node:type() == 'link_text' then
    -- [desc](link)  [[shortcut]]
    --  ^^^^           ^^^^^^^^
    local parent = node:parent()
    if parent:type() == 'shortcut_link' then
      link = parent:child(1)
      linkType = 'shortcut_link'
    elseif parent:type() == 'inline_link' then
      link = node:parent():child(4)
      linkType = 'inline_link'
    end
  elseif node:type() == 'link_destination' then
    -- [desc](link)
    --        ^^^^
    link = node
    linkType = 'inline_link'
  elseif node:type() == 'inline' and node:child_count() > 2 then
    local cur = vim.api.nvim_win_get_cursor(0)
    cur[1] = cur[1] - 1 -- 0-based lines in ts
    cur[2] = cur[2] + 1 -- get next column node
    local nextColNode = vim.treesitter.get_node { pos = cur, ignore_injections = false }
    if nextColNode and nextColNode:type() == 'shortcut_link' then
      -- [[shortcut]]  other inline text
      -- ^          ^
      link = nextColNode:child(1)
      linkType = 'shortcut_link'
    end
  elseif node:type() == 'shortcut_link' then
    --
    link = node:child(1)
    linkType = 'shortcut_link'
  end
  return link and vim.treesitter.get_node_text(link, 0), linkType
end

-- Create link under cursor or jump if already exists (like gd)
ft.addMap('n', '<CR>', function()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  local def = vim.lsp.buf_request_sync(0, 'textDocument/definition', params, 2000)
  -- print('dev', vim.inspect(def))
  if def and def[1] and def[1].result then
    -- if there is a valid definition under the cursor, go to it
    vim.lsp.buf.definition()
    return
  end
  -- there is no definition under the cursor
  local title, linkType = assert(getLink())
  local link = title:gsub('%s+', '_')
  local stat = vim.uv.fs_stat(link)
  local bufname = vim.api.nvim_buf_get_name(0)
  if not stat or stat.type == 'directory' or link:sub(-1, -1) == '/' then
    if bufname:find '/index%.md$' then
      -- if current file is an index, the definition doesn't exist and is a
      -- directory, then assume it is also an index
      link = link:gsub('/+$', '') .. '/index.md'
    end
  end
  if not vim.fs.basename(link):find '^%.*.+%.%a+$' then
    -- if there is no suffix, append '.md'
    link = link .. '.md'
  end

  local function cb(path)
    if not path then return end
    vim.cmd.edit(path)
    if linkType == 'shortcut_link' and vim.api.nvim_buf_line_count(0) then
      path = path:gsub('%.md$', ''):gsub('/index', '')
      vim.api.nvim_buf_set_lines(0, 0, 1, true, { '', '# ' .. title, '', '' })
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
    end
  end

  if stat then
    cb(link)
  else
    vim.ui.input({
      prompt = 'Edit File:',
      default = link,
      completion = 'file'
    }, cb)
  end
end, {
  silent = true,
  desc = 'Go to definition or create file'
})

local function pf(f, ...) print(string.format(f, ...)) end
local function nt(n) return vim.treesitter.get_node_text(n, 0) end
local function pn(n)
  if not n then
    print 'No node'
    return
  end
  local p = n:parent()
  local np = n:prev_sibling()
  local nn = n:next_sibling()
  local npn = n:prev_named_sibling()
  local nnn = n:next_named_sibling()
  local cc = n:child_count()
  local rsr, rsc, rer, rec = n:range()
  pf('node[%d]: (%s) %s %d:%d => %d:%d', cc, n:type(), nt(n), rsr, rsc, rer, rec)
  if rsc == 0 then
    print '(no before node; start of line)'
  else
    local bn = vim.treesitter.get_node { pos = { rsr, rsc - 1 } }
    if bn then
      pf('before node: (%s) %s', bn:type(), nt(bn))
    else
      print '(no before node)'
    end
  end
  if p then pf('parent: (%s) %s', p:type(), nt(p), p) end
  if np then pf('prev sib: (%s) %s', np:type(), nt(np), np) end
  if nn then pf('next sib: (%s) %s', nn:type(), nt(nn), nn) end
  if npn then pf('prev sib: (%s) %s', npn:type(), nt(npn), npn) end
  if nnn then pf('next sib: (%s) %s', nnn:type(), nt(nnn), nnn) end
  for i = 0, cc - 1 do
    local c = n:child(i)
    pf('child[%d]: (%s) %s', i, c:type(), nt(c))
  end
  print(string.rep('=', 20))
end

ft.addCmd('Figlet', function(opts)
  require 'figlet'.figlet(opts.fargs, opts.bang, function(lines)
    local l = opts.line1
    vim.api.nvim_buf_set_lines(0, l, l, true, { '```', '```' })
    l = l + 1
    vim.api.nvim_buf_set_lines(0, l, l, true, lines)
    vim.api.nvim_win_set_cursor(0, { l, 0 })
  end)
end, {
  nargs = '+',
  bang = true,
  complete = require 'figlet'.completion,
  count = true,
})


ft.addCmd('FigletFzf', function()
  vim.ui.input({ prompt = 'Text: ' }, function(text)
    local sel = require 'fzf-lua'.fzf_exec(require 'figlet'.getfonts(), {
      preview = 'figlet -f {} "' .. text:gsub('\\', '\\\\'):gsub('"', '\\"') .. '"',
      complete = function(selected)
        vim.cmd.Figlet({ args = { '-f', selected[1], text }, bang = true })
      end
    })
    if not sel then return end
  end)
end)


-- for debugging
ft.addMap('n', '<Leader><CR>', function()
  -- vim.cmd.mess 'clear'
  local n = require 'nvim-treesitter.ts_utils'.get_node_at_cursor(0)
  pn(n)
  -- pn(n:parent())
  -- pn(n:prev_sibling() and n:prev_sibling():prev_sibling())
  vim.api.nvim__redraw { flush = true, statusline = true }
  local mess = vim.api.nvim_replace_termcodes(':mess<CR>', true, true, true)
  vim.api.nvim_feedkeys(mess, 'nt!', false)
end, { silent = false })
