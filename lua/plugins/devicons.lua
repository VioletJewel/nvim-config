return {
  { 'nvim-tree/nvim-web-devicons',
    cond = Event 'UIEnter',
    config = function()
      require 'nvim-web-devicons'.setup {
        override = { markdown = { icon = "" } },
        override_by_extension = { md = { icon = "" } },
      }
    end,
  };
}
