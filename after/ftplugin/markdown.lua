local lo = vim.opt_local

lo.concealcursor = ''
lo.conceallevel = 0

lo.formatoptions:append '2'
lo.formatoptions:append 'n'

lo.foldlevel = 0

lo.softtabstop = 2
lo.tabstop = 2
lo.shiftwidth = 2

local todo_items = ' x/-'

vim.keymap.set('n', '<Tab>', function()-->
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
  buffer = true,
  silent = true,
  desc = 'Cycle through markdown things!'
})--<

vim.keymap.set('n', '<S-Tab>', function()-->
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find('^%s*- %[[' .. todo_items .. ']%]')
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    local char_ind = (todo_ind - 2) % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
end, {
  buffer = true,
  silent = true,
  desc = 'Cycle backwards through markdown things!'
})--<

vim.keymap.set('n', '<CR>', function()-->
  local lnr = vim.api.nvim_win_get_cursor(0)[1]
  local ep = vim.fn.searchpos([[\[\[.\{-}\]\]\%(\%>.c\)\@=]], 'ce', lnr)[2]
  if ep == 0 then return end
  local sp = vim.fn.searchpos([[\%(\[\[\)\@<=]], 'cb', lnr)[2]
  -- local nt = vim.treesitter.get_node_text(tsu.get_node_at_cursor(), 0)
  local nt = vim.fn.getregion({0,lnr,sp,0},{0,lnr,ep-2})[1]
  local f = vim.fs.joinpath(
    vim.fn.expand '%:h',
    nt:gsub('[ \t`~!@#$%^&*()+=]+', '') .. '.md'
  )
  if vim.uv.fs_stat(f) then return end
  local fd = vim.uv.fs_open(f, 'w', 420)
  if not fd then return end
  vim.uv.fs_write(fd, { '# ' .. nt })
  local cur = vim.api.nvim_win_get_cursor(0)
  vim.cmd.w{ mods = { silent = true } }
  vim.cmd.redraw()
  vim.cmd.e{ mods = { silent = true } }
  vim.api.nvim_win_set_cursor(0, cur)
end, {
  buffer = true,
  silent = true,
  desc = 'Create file under cursor'
})--<

--> undo_ftplugin
vim.b.undo_ftplugin = table.concat(vim.tbl_map(function(t)
  return "exe 'sil! " .. t[1] .. ' <buffer> ' .. t[2] .. "'"
end, {
    { 'nunmap', '<Tab>' },
    { 'nunmap', '<S-Tab>' },
}), '|')--<
