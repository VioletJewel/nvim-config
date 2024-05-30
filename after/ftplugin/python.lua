
require'utils'.map{
  'n <LL>S :pyfile %<CR>',
  buffer=true,
}

vim.b.undo_ftplugin = 'nunmap <buffer> <LocalLeader>S'

