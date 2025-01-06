-- local event = require 'pckr.loader.event'
return {

  { 'vyfor/cord.nvim',
    run = './build',
    -- cond = event 'UIEnter',
    start = true,
    config = function()
      require 'cord'.setup()
    end,
  },

}
