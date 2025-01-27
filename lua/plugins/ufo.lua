-- local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'


return {
  {
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    keys('n', 'zR'),
    keys('n', 'zM'),
    config = function()
      require 'ufo'.setup({
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end
      })
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  }
}
