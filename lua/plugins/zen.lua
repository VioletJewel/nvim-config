return {
  {
    'folke/zen-mode.nvim',
    cond = {
      Keys('n', '<M-CR>'),
      Cmd 'ZenMode',
    },
    config = function()
      require 'zen-mode'.setup {
        window = {
          height = 40,
        },
        plugins = {
          options = {
            ruler = true
          },
        },
      }
      vim.keymap.set('n', '<M-CR>', function() require 'zen-mode'.toggle() end)
    end,
  },
}
