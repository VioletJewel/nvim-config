do return end
-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {
  {
    'vyfor/cord.nvim',
    run = './build',
    -- cond = event 'UIEnter',
    config = function()
      require 'cord'.setup()
    end,
  },
}
