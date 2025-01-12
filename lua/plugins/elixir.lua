-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {
  {
    'elixir-editors/vim-elixir',
    cond = event('FileType', 'elixir'),
  }
}
