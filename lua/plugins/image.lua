local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

local rocksDeps = {
  { 'magick', withArgs = '--dev' },
}

return {

  {
    '3rd/image.nvim',
    cond = cmd 'ImageReport',
    run = function()
      require 'utils.rocks'.ensureRocks()
    end,
    config = function()
      require 'utils.rocks'.ensureRocks(rocksDeps, function()
        require 'image'.setup {
          backend = 'ueberzug',
          processor = 'magick_rock',
          markdown = {
            enabled = true,
            clear_in_insert_mode = true,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            floating_windows = false,
            filetypes = { 'markdown' },
          },
          neorg = {
            enabled = true,
            filetypes = { 'norg' },
          },
        }
      end)
    end
  },

  -- {
  --   'edluffy/hologram.nvim',
  --   config = function()
  --     require 'hologram'.setup {
  --       auto_display = true -- WIP automatic markdown image display, may be prone to breaking
  --     }
  --   end,
  -- }

}
