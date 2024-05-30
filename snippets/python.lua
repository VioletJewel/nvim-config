local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
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

  s('#!', {
    t{'#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', ''},
  }),

  s('def', {
    t'def ',
    i(1, 'foo'),
    t'(',
    i(2, ''),
    t')',
    f(function(args)
      return not args[1][1]:match('^%s*$') and {' -> '} or {}
    end, 3),
    c(3, {
      t'',
      t'int',
      t'str',
      s(nil, {
        i(1, 'tuple'),
        t'[',
        i(2, 'int'),
        t']',
      })
    }),
    t{':','\t"""'},
    i(4, 'Description'),
    d(5, function(args)
      local lines = {}
      local loopnum = 1
      for _,aline in ipairs(args[1]) do
        aline = aline:gsub('%s*,%s*$', '')
        aline = aline:gsub('^%s+', '')
        for m in (aline..','):gmatch('(.-)%s*,') do
          if not m:match('^%s*$') then
            local typ = nil -- param type
            local def = nil -- param default value
            local i1, i2
            m = m:gsub('^%s+','',1)
            i1, i2 = m:find('%s*=%s*')
            if i1 then
              def = m:sub(i2+1)
              m = m:sub(1, i1-1)
            end
            i1, i2 = m:find('%s*:%s*')
            if i1 then
              typ = m:sub(i2+1)
              m = m:sub(1, i1-1)
            end
          if #lines > 0 then
            lines[#lines+1] = t{'',''}
          end
            lines[#lines+1] = t('\t\t'..m)
            if typ then
              lines[#lines+1] = t(' ('..t..(def and ' optional' or '')..')')
            elseif def then
              lines[#lines+1] = t' (optional)'
            end
            lines[#lines+1] = t': '
            lines[#lines+1] = i(loopnum, 'param description')
            loopnum = loopnum + 1
            if def then
              lines[#lines+1] = t'. Defaults to '
              lines[#lines+1] = i(loopnum, def)
              loopnum = loopnum + 1
            end
          end
        end
      end
      if #lines > 0 then
        table.insert(lines, 1, t{'', '', '\tArgs:', ''})
      end
      return s(nil, lines)
    end, 2),
    d(6, function(args)
      if not args[1][1] or args[1][1]:match'^%s*$' then
        return s(nil, {})
      end
      return s(nil, {
        t{'','','\tReturns:','\t\t'},
        i(1, args[1][1]), --:gsub('^%s*(.-)%s*$', '%1')),
        t': ',
        i(2, 'return description')
      })
    end, 3),
    t{'', '\t"""', '\t'},
    i(7, 'pass')
  }),

  s('defmain', {
    t{'def main():', '\t'},
    i(1, 'pass'),
    t{'', '', 'if __name__ == "__main__":', '\tmain()'}
  }),

}
