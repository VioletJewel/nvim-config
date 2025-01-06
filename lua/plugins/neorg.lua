local cmd = require 'pckr.loader.cmd'
local fh = assert(io.popen 'xdg-user-dir DOCUMENTS')
local notesDir = vim.fs.joinpath(fh:read(), 'Notes')
fh:close()

return {
   { "nvim-neorg/neorg",
    tag = "*", -- Pin Neorg to the latest stable release
    cond = cmd 'Neorg',
    config = function()
      require 'rocks'.setup()
      local failed = require 'rocks'.ensureAll {
        'lua-utils.nvim',
        'nvim-nio',
        'nui.nvim',
        'plenary.nvim',
        'pathlib.nvim',
      }
      if #failed > 0 then
        vim.notify('Failed to ensure rocks: ' .. table.concat(failed, ', '), vim.log.levels.ERROR)
        return
      end
      require 'neorg'.setup {
        load = {
          ['core.defaults'] = {},
          ['core.dirman'] = {
            config = {
              workspaces = {
                notes = notesDir
              },
              default_workspace = 'notes'
            },
          },
          ['core.concealer'] = {},
          ['core.latex.renderer'] = {},
          ['core.summary'] = {},
        },
      }
    end,
  };
}
