-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'


return {
  {
    'https://github.com/nvim-orgmode/orgmode',
    tag = '*',
    cond = event('FileType', 'org'),
    config = function()
      require 'orgmode'.setup {
        org_agenda_files = {'~/dokumentujo/org/*'},
        org_default_notes_file = '~/dokumentujo/org/refile.org',
      }
    end,
  }
}
