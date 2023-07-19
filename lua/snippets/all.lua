local ls = require'luasnip'
local lsx = require'luasnip.extras'
-- local lsf = require'luasnip.extras.fmt'

local snippet = ls.snippet
local part = lsx.partial

return {
  snippet('date', part(os.date, '%d %B %Y')),
  snippet('datet', part(os.date, '%Y-%m-%d')),
}
