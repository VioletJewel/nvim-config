vim.keymap.set('n', '<LocalLeader>S', '<Cmd>luafile %<CR>', {
  buffer = true,
  desc = 'run current lua file'
})

vim.b.undo_ftplugin = 'nunmap <buffer> <LocalLeader>S'
