local ls = require'luasnip'
-- local lsf = require'luasnip.extras.fmt'
-- local lsx = require'luasnip.extras'

local snippet = ls.snippet
local text = ls.text_node
local ins = ls.insert_node
local dyn = ls.dynamic_node
local func = ls.function_node
local snip = ls.snippet_node
local choice = ls.choice_node
-- local fmt = lsf.fmt

return {

  snippet('#!', {
    text{'#!/usr/bin/env python3', '# -*- coding: utf-8 -*-', ''},
  }),

  snippet('def', {
    text'def ',
    ins(1, 'foo'),
    text'(',
    ins(2, ''),
    text')',
    func(function(args)
      return not args[1][1]:match('^%s*$') and {' -> '} or {}
    end, 3),
    choice(3, {
      text'',
      text'int',
      text'str',
      snip(nil, {
        ins(1, 'tuple'),
        text'[',
        ins(2, 'int'),
        text']',
      })
    }),
    text{':','\t"""'},
    ins(4, 'Description'),
    dyn(5, function(args)
      local lines = {}
      local loopnum = 1
      for _,aline in ipairs(args[1]) do
        aline = aline:gsub('%s*,%s*$', '')
        aline = aline:gsub('^%s+', '')
        for m in (aline..','):gmatch('(.-)%s*,') do
          if not m:match('^%s*$') then
            local t = nil -- param type
            local d = nil -- param default value
            local i1, i2
            m = m:gsub('^%s+','',1)
            i1, i2 = m:find('%s*=%s*')
            if i1 then
              d = m:sub(i2+1)
              m = m:sub(1, i1-1)
            end
            i1, i2 = m:find('%s*:%s*')
            if i1 then
              t = m:sub(i2+1)
              m = m:sub(1, i1-1)
            end
          if #lines > 0 then
            lines[#lines+1] = text{'',''}
          end
            lines[#lines+1] = text('\t\t'..m)
            if t then
              lines[#lines+1] = text(' ('..t..(d and ' optional' or '')..')')
            elseif d then
              lines[#lines+1] = text' (optional)'
            end
            lines[#lines+1] = text': '
            lines[#lines+1] = ins(loopnum, 'param description')
            loopnum = loopnum + 1
            if d then
              lines[#lines+1] = text'. Defaults to '
              lines[#lines+1] = ins(loopnum, d)
              loopnum = loopnum + 1
            end
          end
        end
      end
      if #lines > 0 then
        table.insert(lines, 1, text{'', '', '\tArgs:', ''})
      end
      return snip(nil, lines)
    end, 2),
    dyn(6, function(args)
      if not args[1][1] or args[1][1]:match'^%s*$' then
        return snip(nil, {})
      end
      return snip(nil, {
        text{'','','\tReturns:','\t\t'},
        ins(1, args[1][1]), --:gsub('^%s*(.-)%s*$', '%1')),
        text': ',
        ins(2, 'return description')
      })
    end, 3),
    text{'', '\t"""', '\t'},
    ins(7, 'pass')
  }),

  snippet('defmain', {
    text{'def main():', '\t'},
    ins(1, 'pass'),
    text{'', '', 'if __name__ == "__main__":', '\tmain()'}
  }),

}
