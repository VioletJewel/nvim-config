return {
  {
    'VioletJewel/vimterm.nvim',
    cond = Event 'UIEnter',
    config = function() require 'vimterm'.setup() end,
  },
}
