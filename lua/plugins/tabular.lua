local cmd = require 'pckr.loader.cmd'

return {
  { 'godlygeek/tabular',
    cond = {
      cmd 'Tabularize',
      cmd 'GTabularize',
    },
  };
}
