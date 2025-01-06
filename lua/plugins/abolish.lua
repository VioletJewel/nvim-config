local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'

return {

  { 'tpope/vim-abolish',
    start = true,
    cond = {
      keys('n', 'cr'),
      cmd 'Abolish',
      cmd 'Subvert',
      cmd 'S',
    },
  },

}
