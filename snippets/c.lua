local ls = require("luasnip")
local s = ls.s
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
-- local extras = require("luasnip.extras")
-- local l = extras.lambda
-- local rep = extras.rep
-- local p = extras.partial
-- local m = extras.match
-- local n = extras.nonempty
-- local dl = extras.dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local conds = require("luasnip.extras.expand_conditions")
-- local postfix = require("luasnip.extras.postfix").postfix
-- local types = require("luasnip.util.types")
-- local parse = require("luasnip.util.parser").parse_snippet
-- local ms = ls.multi_snippet
-- local k = require("luasnip.nodes.key_indexer").new_key

return {

  s('main', {
    t{'int main(int argc, char *argv[]) {', '\t'},
    i(1, ''),
    t{'', '\treturn 0;', '}'}
  }),

  s('p', {
    t'printf("',
    i(1, '%d'),
    t'"',
    d(2, function(args)
      local toks = {}
      if args[1][1]:gsub('%%%%', ''):match'%%' then
        table.insert(toks, t', ')
        table.insert(toks, i(1, ''))
      end
      return ls.snippet_node(nil, toks)
    end, 1),
    t');',
  }),

  s('i', {
    t'#include ',
    c(2, {
      t'<',
      t'"',
    }),
    i(1, 'stdio'),
    t'.h',
    d(3, function(args)
      return s(nil, {t(args[1][1] == '<' and '>' or args[1][1])})
    end, 2),
  }),

}
