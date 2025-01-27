-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'
local lua = require 'pckr.loader.lua'


return {
  {
    'https://github.com/nvim-orgmode/orgmode',
    tag = '*',
    -- cond = event('FileType', 'org'),
    cond = lua 'orgmode',
    config = function()
      require 'orgmode'.setup {
        org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
        org_default_notes_file = '~/Dropbox/org/refile.org',
      }
    end,
  }
}
