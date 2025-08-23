return {

  {
    'mlochbaum/BQN',
    cond = Event('FileType', 'bqn'),
    config = function()
      local datadir = vim.fn.stdpath 'data' --- @cast datadir string
      vim.opt.rtp:append(vim.fs.joinpath(datadir, 'site', 'pack', 'pckr', 'opt', 'BQN', 'editors', 'vim'))
    end,
  },

  {
    'https://git.sr.ht/~detegr/nvim-bqn',
    cond = Event('FileType', 'bqn'),
    config_pre = function() vim.g.nvim_bqn = 'bqn' end,
  },

}
