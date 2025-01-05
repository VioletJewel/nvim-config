return {

  { 'folke/tokyonight.nvim',
    config = function()
      require 'utils'.augroup 'VioletTheme' { 'UIEnter', callback = function()
        -- vim.cmd.syntax 'reset'
        vim.cmd.colorscheme 'tokyonight'
        vim.cmd.doautocmd { args = { 'colorscheme', 'tokyonight' } }
      end }
    end,
  };

  'rebelot/kanagawa.nvim';

  'catppuccin/nvim';

  'lifepillar/gruvbox8';

  'sainnhe/sonokai';

  'dracula/vim';

  'owickstrom/vim-colors-paramount';

  'violetjewel/color-nokto';

  'violetjewel/color-vulpo';

  'navarasu/onedark.nvim';

  'gbprod/nord.nvim';

  -- 'b0o/lavi.nvim';

}
