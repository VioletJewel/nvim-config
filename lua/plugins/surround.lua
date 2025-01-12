-- local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {
  {
    'kylechui/nvim-surround',
    cond = {
      keys('n', 'ys'),
      keys('n', 'ds'),
      keys('n', 'cs'),
      keys('n', 'yS'),
      keys('n', 'cS'),
      keys('i', '<C-g>s'),
      keys('i', '<C-g>S'),
      keys({ 'n', 'x' }, 'S'),
      keys('x', 'gS'),
    },
    config = function() require 'nvim-surround'.setup() end,
  },
}
