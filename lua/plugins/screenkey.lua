return {
  'NStefan002/screenkey.nvim',
  name = 'screenkey',
  init = function()
    vim.g.screenkey_statusline_component = true
  end,
  config = function()
    require 'screenkey'.setup {
      win_opts = {
        width = vim.fn.winwidth(0),
        title = '',
        height = 1,
        noautocmd = false,
      },
      keys = {
        ['<ESC>'] = '⎋',
      }
    }
    vim.api.nvim_create_user_command('Screenkey', function()
      vim.o.winbar = vim.o.winbar and nil or "%{%v:lua.require('screenkey').get_keys()%}"
    end, {})
  end,
  cmd = 'Screenkey',
}
