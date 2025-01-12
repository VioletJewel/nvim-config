local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {
  {
    'godlygeek/tabular',
    cond = {
      cmd 'Tabularize',
      cmd 'GTabularize',
    },
  },
}
