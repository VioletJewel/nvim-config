return {
  {
    'L3MON4D3/LuaSnip',
    tag = "v2.*",
    run = 'make install_jsregexp',
    -- cond = {
    --   Keys({ 'n', 'i', 's' }, '<M-Space>'),
    --   Keys({ 'n', 'i', 's' }, '<M-h>'),
    --   Keys({ 'n', 'i', 's' }, '<M-l>'),
    --   Keys({ 'n', 'i', 's' }, '<M-j>'),
    --   Keys({ 'n', 'i', 's' }, '<M-k>'),
    --   Cmd 'LuaSnipListAvailable',
    --   Cmd 'LuaSnipUnlinkCurrent',
    -- },
    config = function()
      local ls = require 'luasnip'
      vim.keymap.set({ 'n', 'i', 's' }, '<M-Space>', function()
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
      local cfg = vim.fn.stdpath 'config' ---@cast cfg string
      require 'luasnip.loaders.from_lua'.lazy_load {
        lazy_paths = vim.fs.joinpath(cfg, 'snippets')
      }
    end,
  },
}
