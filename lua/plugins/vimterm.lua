-- local event = require 'pckr.loader.event'

return {
  { 'VioletJewel/vimterm.nvim',
    -- cond = event 'UIEnter',
    start = true,
    config = function() require 'vimterm'.setup() end,
  };
}
