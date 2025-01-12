local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {
  {
    'folke/zen-mode.nvim',
    cond = {
      keys('n', '<Space>z'),
      cmd 'ZenMode',
    },
    config = function()
      require 'zen-mode'.setup()
      vim.keymap.set('n', '<Leader>z', function() require 'zen-mode'.toggle() end)
    end,
  },
}
