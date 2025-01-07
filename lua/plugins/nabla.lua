local au = require 'utils'.augroup 'ViNabla'

return {
  { 'jbyuki/nabla.nvim',
    config = function()
      -- require 'nabla'.enable_virt { autogen = true, silent = true }
      au {
        'FileType',
        pattern = { 'markdown', 'norg' },
        callback = function()
          local nabla = require 'nabla'
          if not nabla.is_virt_enabled() then
            nabla.enable_virt { autogen = true, silent = true }
          end
        end
      }
    end,
  }
}
