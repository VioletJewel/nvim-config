local plugs = vim.iter(ipairs {
      'insert', 'insert-line', 'normal', 'normal-cur', 'normal-line',
      'normal-cur-line', 'visual', 'visual-line', 'delete', 'change',
      'change-line',
    })
    :map(function(_, n) return '<Plug>(nvim-surround-' .. n .. ')' end)
    :totable()

return {
  'kylechui/nvim-surround',
  name = 'surround',
  opts = {},
  keys = {
    'ys', 'ds', 'cs', 'yS', 'cS',
    { '<C-g>s', mode = 'i' }, { '<C-g>S', mode = 'i' },
    { 'S', mode = { 'n', 'x' } }, { 'gS', mode = 'x' },
    unpack(plugs)
  },
}
