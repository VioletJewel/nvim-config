local event = require 'pckr.loader.event'

return {

  { '3rd/image.nvim',
    cond = event 'UIEnter',
    requires = { "nvim-treesitter/nvim-treesitter", 'nvim-neorg/neorg' },
    config = function()
      require 'rocks'.setup()
      if require 'rocks'.ensure 'magick' ~= 0 then return end
      require 'image'.setup {
        backend = 'kitty',
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      }
    end
  },

}
