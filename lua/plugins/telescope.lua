local map = vim.keymap.set

return {

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'
      map('n', '<Leader>ff', builtin.find_files, {})
      map('n', '<Leader>fg', builtin.live_grep, {})
      map('n', '<Leader>fb', builtin.buffers, {})
      map('n', '<Leader>fh', builtin.help_tags, {})
    end,
  }

}
