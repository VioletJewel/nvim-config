-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {

  {
    'kwakzalver/duckytype.nvim',
    config = function()
      require('duckytype').setup{
        number_of_words = 100,
        highlight = {
          good = "Comment",
          bad = "Error",
          remaining = "Todo",
        },
      }
    end,
  },

}
