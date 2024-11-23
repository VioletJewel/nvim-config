vim.keymap.set('n', '<LocalLeader>S', '<Cmd>pyfile %<CR>', {
  buffer = true,
  desc = 'run current python file'
})

vim.b.undo_ftplugin = 'nunmap <buffer> <LocalLeader>S'
