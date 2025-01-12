local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {

  {
    'nanotee/zoxide.vim',
    requires = { 'ibhagwan/fzf-lua' },
    cond = {
      cmd 'Z',
      cmd 'Lz',
      cmd 'Tz',
      cmd 'Zi',
      cmd 'Lzi',
      cmd 'Tzi',
      keys('n', '<Bslash>z', ':<C-u>Zi<CR>', { desc = '[F]ZF [Z]oxide CD' }),
    },
    config_pre = function()
      vim.g.zoxide_use_select = 1
    end,
    config = function()
      require 'fzf-lua'.register_ui_select()
      vim.api.nvim_set_keymap('n', '<LocalLeader>z', ':Zi<CR>', { noremap = true, desc = '[F]ZF [Z]oxide CD' })
    end,
  },

}
