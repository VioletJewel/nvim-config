-- local event = require 'pckr.loader.event'
return {
  { 'nvim-tree/nvim-web-devicons',
    -- cond = event 'UIEnter',
    start = true,
    config = function()
      require 'nvim-web-devicons'.setup {
        override = { markdown = { icon = "" } },
        override_by_extension = { md = { icon = "" } },
      }
    end,
  };
}
