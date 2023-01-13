-- Author: Violet
-- Last Change: 12 January 2023

local au = require'utils'.buildaugroup('VioletLuasnip')

local ok, loader = pcall(require, 'luasnip.loaders.from_lua')
if not ok then
  return
end
loader.lazy_load{paths=vim.fn.stdpath'config'..'/lua/snippets'}

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

-- auto-read skeleton in for new snippet file
au{ 'BufNewFile', [[call setline(1, readfile(stdpath('config')..'/lua/snippets/.skel'))]], pattern=vim.fn.stdpath('config')..'/lua/snippets/*.lua' }
au{ 'BufNewFile', [[echo 'New snippet buffer created; read snippet skeleton (lua/snippets/.skel)']], pattern=vim.fn.stdpath('config')..'/lua/snippets/*.lua' }

