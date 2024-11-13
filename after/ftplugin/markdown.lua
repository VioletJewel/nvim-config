local l = vim.opt_local

l.concealcursor = ''
l.conceallevel = 0

l.formatoptions:append '2'
l.formatoptions:append 'n'

l.foldlevel = 0

l.softtabstop = 2
l.tabstop = 2
l.shiftwidth = 2

local todo_items = ' x/-'

vim.keymap.set('n', '<Tab>', function()
  local l = vim.go.lazyredraw
  vim.go.lazyredraw = true
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find '^%s*- %[[-/ x]%]'
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    local char_ind = todo_ind % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
  vim.go.lazyredraw = false
  vim.cmd.redraw()
end, {
  buffer = true,
  silent = true,
  desc = 'Cycle through markdown things!'
})

vim.keymap.set('n', '<S-Tab>', function()
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find '^%s*- %[[-/ x]%]'
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    print('todo_ind', todo_ind)
    local char_ind = (todo_ind - 2) % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
end, {
  buffer = true,
  silent = true,
  desc = 'Cycle backwards through markdown things!'
}
)

vim.b.undo_ftplugin = "exe 'sil! nunmap <buffer> <Tab>' | exe 'sil! nunmap <buffer> <S-Tab>'"
