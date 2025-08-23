return {
  {
    'https://github.com/nvim-orgmode/orgmode',
    tag = '*',
    cond = Event('FileType', 'org'),
    config = function()
      require 'orgmode'.setup {
        org_agenda_files = {'~/dokumentujo/org/*'},
        org_default_notes_file = '~/dokumentujo/org/refile.org',
      }
    end,
  }
}
