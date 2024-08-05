return {

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<LocalLeader>ff', builtin.find_files, { desc = 'find files with telescope' })
      vim.keymap.set('n', '<LocalLeader>fg', builtin.live_grep,  { desc = 'grep files with telescope' })
      vim.keymap.set('n', '<LocalLeader>fb', builtin.buffers,    { desc = 'find buffers with telescope' })
      vim.keymap.set('n', '<LocalLeader>fh', builtin.help_tags,  { desc = 'find help tags with telescope' })
    end,
  }

}
