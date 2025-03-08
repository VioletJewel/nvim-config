-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

local au = require 'utils.augroup' 'ViPluginThemes'

local theme
if os.getenv 'TERM' == 'linux' then
  theme = 'linux'
  vim.o.termguicolors = false
elseif os.getenv 'DVTM' and os.getenv 'DVTM_WINDOW_ID' then
  theme = 'sonokai'
  vim.o.termguicolors = false
  vim.g.sonokai_enable_italic = 1
  vim.g.sonokai_style = 'andromeda'
elseif os.getenv 'ASCIINEMA_REC' == '1' then
  theme = 'sonokai'
  vim.o.termguicolors = false
  vim.g.sonokai_enable_italic = 1
  vim.g.sonokai_style = 'andromeda'
else
  theme = os.getenv 'NVIM_THEME' or 'tokyonight'
  if os.getenv 'NVIM_NOTGC' then
    vim.o.termguicolors = false
  end
end

au {
  'VimEnter',
  callback = function()
    pcall(vim.cmd.colorscheme, theme)
    vim.cmd.doautocmd { args = { 'ColorScheme', theme } }
  end
}

return {

  'folke/tokyonight.nvim',

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

  -- 'b0o/lavi.nvim',

  'EdenEast/nightfox.nvim',

}
