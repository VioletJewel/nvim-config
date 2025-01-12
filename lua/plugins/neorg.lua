local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

local fh = assert(io.popen 'xdg-user-dir DOCUMENTS')
local notesDir = vim.fs.joinpath(fh:read(), 'notes')
fh:close()

-- -- Uncomment if you need to re-install Rocks for neorg
-- vim.api.nvim_create_user_command('InstallNeorgRocks', installRocksDeps, {})

local rocksDeps = {
  'lua-utils.nvim',
  'nvim-nio',
  'nui.nvim',
  'plenary.nvim',
  'pathlib.nvim',
}

return {
  {
    'nvim-neorg/neorg',
    requires = { '3rd/image.nvim' },
    tag = '*', -- Pin Neorg to the latest stable release
    -- cond = {
    --   cmd 'Neorg',
    --   keys('n', '<Leader>nj'),
    --   keys('n', '<Leader>ni'),
    --   keys('n', '<Leader>nc'),
    -- },
    run = function()
      require 'utils.rocks'.ensureRocks(rocksDeps)
    end,
    config = function()
      vim.keymap.set('n', '<Leader>nj', '<Cmd>Neorg journal today<CR>')
      vim.keymap.set('n', '<Leader>ni', '<Cmd>Neorg index<CR>')
      vim.keymap.set('n', '<Leader>nc', '<Cmd>Neorg toggle-concealer<CR>')
      require 'utils.rocks'.ensureRocks(rocksDeps, function()
        require 'neorg'.setup {
          load = {
            ['core.defaults'] = {},
            ['core.dirman'] = {
              config = {
                workspaces = { notes = notesDir },
                default_workspace = 'notes'
              },
            },
            ['core.journal'] = {
              journal_folder = 'areas/journal',
              strategy = 'flat',
              workspace = 'notes',
            },
            ['core.integrations.treesitter'] = {},
            ['core.concealer'] = {},
            ['core.summary'] = {},
          },
        }
      end)
    end,
  },
}
