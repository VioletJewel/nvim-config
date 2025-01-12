local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {
  {
    'L3MON4D3/LuaSnip',
    tag = "v2.*",
    run = 'make install_jsregexp',
    cond = {
      keys({ 'n', 'i', 's' }, '<M-Space>'),
      keys({ 'n', 'i', 's' }, '<M-h>'),
      keys({ 'n', 'i', 's' }, '<M-l>'),
      keys({ 'n', 'i', 's' }, '<M-j>'),
      keys({ 'n', 'i', 's' }, '<M-k>'),
      cmd 'LuaSnipListAvailable',
      cmd 'LuaSnipUnlinkCurrent',
    },
    config = function()
      local ls = require 'luasnip'
      local cfg = vim.fn.stdpath 'config' ---@cast cfg string
      require 'luasnip.loaders.from_lua'.lazy_load {
        lazy_paths = vim.fs.joinpath(cfg, 'snippets')
      }
      vim.keymap.set({ 'n', 'i', 's' }, '<M-space>', function()
        if ls.expandable() then ls.expand() end
      end, {
        desc = 'expand luasnip snippet when possible'
      })
      vim.keymap.set({ 'n', 'i', 's' }, '<M-h>', function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, {
        desc = 'jump to previous luasnip node'
      })
      vim.keymap.set({ 'n', 'i', 's' }, '<M-l>', function()
        if ls.jumpable(1) then ls.jump(1) end
      end, {
        desc = 'jump to next luasnip node'
      })
      vim.keymap.set({ 'n', 'i', 's' }, '<M-j>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end, {
        desc = 'cycle forwards through luasnip node choices'
      })
      vim.keymap.set({ 'n', 'i', 's' }, '<M-k>', function()
        if ls.choice_active() then ls.change_choice(-1) end
      end, {
        desc = 'cycle backwards through luasnip node choices',
      })
    end,
  },
}
