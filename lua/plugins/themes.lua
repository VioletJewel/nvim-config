-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {

  {
    'folke/tokyonight.nvim',
    cond = event 'VimEnter',
    config = function()
      if os.getenv 'ASCIINEMA_REC' == '1' then
        vim.o.termguicolors = false
        vim.g.sonokai_enable_italic = 1
        vim.g.sonokai_style = 'andromeda'
        vim.cmd.colorscheme 'sonokai'
        vim.cmd.doautocmd { args = { 'ColorScheme', 'sonokai' } }
      else
        vim.cmd.colorscheme 'tokyonight'
        vim.cmd.doautocmd { args = { 'ColorScheme', 'tokyonight' } }
      end
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
