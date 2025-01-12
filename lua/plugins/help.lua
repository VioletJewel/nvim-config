local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {

  { 'tweekmonster/helpful.vim',
    cond = cmd 'HelpfulVersion',
  },

  { 'OXY2DEV/helpview.nvim',
    requires = { "nvim-treesitter/nvim-treesitter" },
    cond = event('FileType', 'help'),
    -- cond = event 'UIEnter',
  },

}
