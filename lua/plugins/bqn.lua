return {
  'https://git.sr.ht/~detegr/nvim-bqn',
  {
    'mlochbaum/BQN',
    config = function(plugin)
      vim.opt.rtp:append(vim.fs.joinpath(plugin.dir, 'editors', 'vim'))
    end,
  },
}
