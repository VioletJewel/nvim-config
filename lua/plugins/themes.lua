-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {

  {
    'folke/tokyonight.nvim',
    cond = event 'UIEnter',
    config = function()
      vim.cmd.colorscheme 'tokyonight'
      vim.cmd.doautocmd { args = { 'colorscheme', 'tokyonight' } }
    end,
  },

  'rebelot/kanagawa.nvim',

  'catppuccin/nvim',

  'lifepillar/gruvbox8',

  'sainnhe/sonokai',

  'dracula/vim',

  'owickstrom/vim-colors-paramount',

  'violetjewel/color-nokto',

  'violetjewel/color-vulpo',

  'navarasu/onedark.nvim',

  'gbprod/nord.nvim',

  'loctvl842/monokai-pro.nvim',

  -- 'b0o/lavi.nvim';

}
