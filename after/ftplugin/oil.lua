local ft = require 'utils.ftplugin'

vim.b.oilShouldHomeNav = true

ft.addMap('n', 'l', function()-->
  return vim.b.oilShouldHomeNav and '<CR>' or 'l'
end, {
  expr = true,
  remap = true,
  desc = 'l opens like <CR> in oil buffer'
})--<

ft.addMap('n', 'h', function()-->
  return vim.b.oilShouldHomeNav and '-' or 'h'
end, {
  expr = true,
  remap = true,
  desc = 'h goes to parent dir like - in oil buffer'
})--<

ft.addMap('n', '<M-l>', function()-->
  vim.b.oilShouldHomeNav = not vim.b.oilShouldHomeNav
  print('h/l navigation enabled: '..(vim.b.oilShouldHomeNav and 'yes' or 'no'))
end, {
  remap = true,
  desc = 'toggles between h/l and cursor movement in oil buffer'
})-->
