return {

  {
    'dracula/vim',
    name = 'dracula',
    event = 'VimEnter',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dracula'
      vim.cmd.doautocmd 'ColorScheme dracula'
    end,
  },

  { 'folke/tokyonight.nvim',           lazy = true },

  { 'lifepillar/gruvbox8',             lazy = true },

  { 'owickstrom/vim-colors-paramount', lazy = true },

  { 'violetjewel/color-nokto',         lazy = true },

  { 'violetjewel/color-vulpo',         lazy = true },

}
