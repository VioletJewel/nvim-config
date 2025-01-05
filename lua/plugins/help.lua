local event = require 'pckr.loader.event'

return {
  'tweekmonster/helpful.vim';

  { 'OXY2DEV/helpview.nvim',
    requires = { "nvim-treesitter/nvim-treesitter" },
    cond = event('FileType', 'help')
  };
}
