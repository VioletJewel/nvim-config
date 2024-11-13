return {
  'folke/zen-mode.nvim',
  name = 'zen-mode',
  opts = {},
  cmd = { 'ZenMode', },
  keys = { { '<LocalLeader>z', function() require 'zen-mode'.toggle() end }, },
}
