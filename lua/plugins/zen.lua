local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {
  {
    'folke/zen-mode.nvim',
    cond = {
      keys('n', '<M-CR>'),
      cmd 'ZenMode',
    },
    config = function()
      require 'zen-mode'.setup {
        window = {
          height = 40,
        },
        plugins = {
          options = {
            ruler = true
          },
        },
      }
      vim.keymap.set('n', '<M-CR>', function() require 'zen-mode'.toggle() end)
    end,
  },
}
