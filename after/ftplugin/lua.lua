vim.keymap.set('n', '<LocalLeader>S', '<Cmd>luafile %<CR>', {
  buffer = true,
  desc = 'run current lua file'
})

--> options specific to nvim config
if vim.startswith(vim.api.nvim_buf_get_name(0), vim.fn.stdpath 'config' .. '/') then
  vim.wo.foldmarker = '-->,--<'
  vim.wo.foldmethod = 'marker'
  vim.wo.foldlevel = 0

  -- TODO: fix zf becaues of foldmarkers that double as comments hehe
  -- vim.api.nvim_set_keymap('x', 'zf', 'opfunc...')
  -- vim.api.nvim_set_keymap('n', 'zf', 'opfunc...')

end--<

vim.b.undo_ftplugin = "setl fdm& fmr& fdl& | nunmap <buffer> <LocalLeader>S"
