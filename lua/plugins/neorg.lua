-- local cmd = require 'pckr.loader.cmd'
local fh = assert(io.popen 'xdg-user-dir DOCUMENTS')
local notesDir = vim.fs.joinpath(fh:read(), 'Notes')
fh:close()

return {
   { "nvim-neorg/neorg",
    tag = "*", -- Pin Neorg to the latest stable release
    config = function()
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
          -- ['core.latex.renderer'] = {},
          ['core.summary'] = {},
        },
      }
    end,
  };
}
