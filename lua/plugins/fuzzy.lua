
return {

  'ibhagwan/fzf-lua',

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require'telescope.builtin'
      vim.tbl_map(require'utils'.map, {
        { 'n <L>ff', builtin.find_files },
        { 'n <L>fg', builtin.live_grep },
        { 'n <L>fb', builtin.buffers },
        { 'n <L>fh', builtin.help_tags },
      })
    end,
  }

}

