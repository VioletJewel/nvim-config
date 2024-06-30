local ls = require 'luasnip'
local lsf = require 'luasnip.extras.fmt'
local lsx = require 'luasnip.extras'

local snippet = ls.snippet
local text = ls.text_node
local ins = ls.insert_node
-- local dyn = ls.dynamic_node
-- local func = ls.function_node
-- local snip = ls.snippet_node
-- local choice = ls.choice_node
local part = lsx.partial
local fmt = lsf.fmt

return {
  snippet('img', fmt('![{}]({})', { ins(1, 'alt'), ins(2, 'img.png') })),
  snippet('link', fmt('[{}]({})', { ins(1, 'txt'), ins(2, 'url') })),
  snippet('meta', fmt('---\ntitle: "{1}"\nauthor: [{2}]\ndate: "{3}"\nkeywords: [{4}]\npapersize: letter\n...', {
    ins(1, 'My Title'),
    ins(2, 'My Name'),
    part(os.date, '%Y-%m-%d'),
    ins(3, 'comma-sep keywords'),
  })),
  snippet('cc', text '- [ ] '),
  snippet('cm', text '- [x] '),
  snippet('si', fmt('`{}`', { ins(1, '') })),
  snippet('ss', fmt('```\n{}\n```', { ins(1, '') })),
}
