-- Author: Violet
-- Last Change: 05 September 2023

local cfg = vim.fn.stdpath'config'

local ok, loader = pcall(require, 'luasnip.loaders.from_lua')
if not ok then
  return
end
loader.lazy_load{paths=cfg..'/lua/snippets'}

local au = require'utils'.augroup'VioletLuasnip'

require'luasnip'.config.set_config({
  history = true,
  update_events = 'TextChanged,TextChangedI',
  delete_check_events = 'TextChanged',
  ext_opts = {
    [require'luasnip.util.types'.choiceNode] = {
      active = { virt_text = { { 'choiceNode', 'Comment' } }, },
    },
  },
  ext_base_prio = 300,
  ext_prio_increase = 1,
  enable_autosnippets = true,
  store_selection_keys = '<m-j>',
})

local function readfile(name)
  local f = io.open(name, 'r')
  if not f then return {} end
  local lines = {}
  for line in f:lines() do
    lines[#lines+1] = line
  end
  return lines
end

-- auto-read skeleton in for new snippet file
au{ 'BufNewFile',
  pattern  = cfg..'/lua/snippets/*.lua',
  callback = function()
    local skel = cfg..'/lua/snippets/.skel'
    vim.fn.setline(1, readfile(skel))
    print('New snippet buffer created from '..string.format('%q', skel))
  end,
}

