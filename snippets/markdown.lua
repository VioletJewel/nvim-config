local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
-- local l = extras.lambda
-- local rep = extras.rep
local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
-- local parse = require("luasnip.util.parser").parse_snippet
-- local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key

return {
  s('img', fmt('![{}]({})', { i(1, 'alt'), i(2, 'img.png') })),
  s('link', fmt('[{}]({})', { i(1, 'txt'), i(2, 'url') })),
  s('meta', fmt('---\ntitle: "{1}"\nauthor: [{2}]\ndate: "{3}"\nkeywords: [{4}]\npapersize: letter\n...', {
    i(1, 'My Title'),
    i(2, 'My Name'),
    p(os.date, '%Y-%m-%d'),
    i(3, 'comma-sep keywords'),
  })),
  s('cc', t'- [ ] '),
  s('cm', t'- [x] '),
  s('si', fmt('`{}`', { i(1, '') })),
  s('ss', fmt('```\n{}\n```', { i(1, '') })),
}
