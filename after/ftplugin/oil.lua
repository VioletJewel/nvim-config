vim.b.oilShouldHomeNav = true

vim.keymap.set('n', 'l', function()-->
  return vim.b.oilShouldHomeNav and '<CR>' or 'l'
end, {
  expr = true,
  buffer = true,
  remap = true,
  desc = 'l opens like <CR> in oil buffer'
})--<

vim.keymap.set('n', 'h', function()-->
  return vim.b.oilShouldHomeNav and '-' or 'h'
end, {
  expr = true,
  buffer = true,
  remap = true,
  desc = 'h goes to parent dir like - in oil buffer'
})--<

vim.keymap.set('n', '<M-l>', function()-->
  vim.b.oilShouldHomeNav = not vim.b.oilShouldHomeNav
  print('h/l navigation enabled: '..(vim.b.oilShouldHomeNav and 'yes' or 'no'))
end, {
  buffer = true,
  remap = true,
  desc = 'toggles between h/l and cursor movement in oil buffer'
})-->
