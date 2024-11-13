return {
  'nanotee/zoxide.vim',
  dependencies = { 'ibhagwan/fzf-lua' },
  config = function() require 'fzf-lua'.register_ui_select() end,
  init = function() vim.g.zoxide_use_select = 1 end,
  keys = { { '<leader>z', ':Zi<CR>', desc = '[F]ZF [Z]oxide CD' }, },
  cmd = { 'Z', 'Zi', 'Lz', 'Lzi', 'Tz', 'Tzi', },
}
