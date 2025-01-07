local keys = require 'pckr.loader.keys'

return {


  { 'nanotee/zoxide.vim',
    requires = { 'ibhagwan/fzf-lua' },
    config_pre = function() vim.g.zoxide_use_select = 1 end,
    cond = keys('n', '<Space>z', ':<C-u>Zi<CR>', { desc = '[F]ZF [Z]oxide CD' }),
    config = function()
      require 'fzf-lua'.register_ui_select()
      vim.api.nvim_set_keymap('n', '<Leader>z', ':Zi<CR>', { desc = '[F]ZF [Z]oxide CD' })
    end,
  },

}
