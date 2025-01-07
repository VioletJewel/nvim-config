require 'rocks'.setup()

local failed = require 'rocks'.ensureAll {
  -- neorg
  'lua-utils.nvim',
  'nvim-nio',
  'nui.nvim',
  'plenary.nvim',
  'pathlib.nvim',
  -- image.nvim
  'magick',
}
if #failed == 0 then return end

vim.notify('Failed to ensure rocks dependencies: ' .. table.concat(failed, ', '), vim.log.levels.ERROR)
