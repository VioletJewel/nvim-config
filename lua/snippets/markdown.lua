local ls = require'luasnip'
local lsf = require'luasnip.extras.fmt'
-- local lsx = require'luasnip.extras'

local snippet = ls.snippet
local text = ls.text_node
local ins = ls.insert_node
local dyn = ls.dynamic_node
local func = ls.function_node
local snip = ls.snippet_node
local choice = ls.choice_node
local fmt = lsf.fmt

return {
  snippet('img', fmt('![{}]({})', { ins(1, 'alt'), ins(2, 'img.png') })),
  snippet('link', fmt('[{}]({})', { ins(1, 'txt'), ins(2, 'url') })),
}
