local event = require 'pckr.loader.event'
local cmd = require 'pckr.loader.cmd'

return {

  { 'tweekmonster/helpful.vim',
    cond = cmd 'HelpfulVersion'
  },

  { 'OXY2DEV/helpview.nvim',
    requires = { "nvim-treesitter/nvim-treesitter" },
    cond = event('FileType', 'help')
  },

}
