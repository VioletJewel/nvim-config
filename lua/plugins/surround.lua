return {
  {
    'kylechui/nvim-surround',
    cond = {
      Keys('n', 'ys'),
      Keys('n', 'ds'),
      Keys('n', 'cs'),
      Keys('n', 'yS'),
      Keys('n', 'cS'),
      Keys('i', '<C-g>s'),
      Keys('i', '<C-g>S'),
      Keys({ 'n', 'x' }, 'S'),
      Keys('x', 'gS'),
    },
    config = function() require 'nvim-surround'.setup() end,
  },
}
