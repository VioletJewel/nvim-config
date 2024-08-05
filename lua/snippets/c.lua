local ls = require'luasnip'
-- local lsx = require'luasnip.extras'
-- local lsf = require'luasnip.extras.fmt'

local snippet = ls.snippet
local text = ls.text_node
local ins = ls.insert_node
local dyn = ls.dynamic_node
-- local func = ls.function_node
local snip = ls.snippet_node
local choice = ls.choice_node

return {

  snippet('main', {
    text{'int main(int argc, char *argv[]) {', '\t'},
    ins(1, ''),
    text{'', '\treturn 0;', '}'}
  }),

  snippet('p', {
    text'printf("',
    ins(1, '%d'),
    text'"',
    dyn(2, function(args)
      local toks = {}
      if args[1][1]:gsub('%%%%', ''):match'%%' then
        table.insert(toks, text', ')
        table.insert(toks, ins(1, ''))
      end
      return ls.snippet_node(nil, toks)
    end, 1),
    text');',
  }),

  snippet('i', {
    text'#include ',
    choice(2, {
      text'<',
      text'"',
    }),
    ins(1, 'stdio'),
    text'.h',
    dyn(3, function(args)
      return snip(nil, {text(args[1][1] == '<' and '>' or args[1][1])})
    end, 2),
  }),

}
