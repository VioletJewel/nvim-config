local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'

return {
  { 'folke/zen-mode.nvim',
    cond = {
      keys('n', '<Bslash>z'),
      cmd 'ZenMode',
    },
    config = function()
      require 'zen-mode'.setup()
      vim.keymap.set('n', '<LocalLeader>z', function() require 'zen-mode'.toggle() end)
    end,
  };
}
