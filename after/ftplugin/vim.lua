vim.keymap.set('n', '<LocalLeader>S', '<Cmd>source %<CR>', {
  buffer = true,
  desc = 'source current vim file'
})

vim.b.undo_ftplugin = 'nunmap <buffer> <LocalLeader>S'
