return {

  {
    'nanotee/zoxide.vim',
    requires = { 'ibhagwan/fzf-lua' },
    cond = {
      Cmd 'Z',
      Cmd 'Lz',
      Cmd 'Tz',
      Cmd 'Zi',
      Cmd 'Lzi',
      Cmd 'Tzi',
      Keys('n', '<Bslash>z', ':<C-u>Zi<CR>', { desc = '[F]ZF [Z]oxide CD' }),
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
