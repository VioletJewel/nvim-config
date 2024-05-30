
return {
  {
    'dracula/vim',
    name = 'dracula',
    event = 'VimEnter',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme'dracula'
      vim.cmd.doautocmd'ColorScheme dracula'
    end,
  },
  'folke/tokyonight.nvim',
  'lifepillar/gruvbox8',
  'owickstrom/vim-colors-paramount',
  'violetjewel/color-nokto',
  'violetjewel/color-vulpo',
}

