local s = function(modes) return vim.split(modes, '') end
local cfg = vim.fn.stdpath 'config' ---@cast cfg string

return {
  {
    'L3MON4D3/LuaSnip',
    name = 'luasnip',
    version = "v2.*",
    build = 'make install_jsregexp',
    config = function()
      require 'luasnip.loaders.from_lua'.lazy_load {
        lazy_paths = vim.fs.joinpath(cfg, 'snippets')
      }
    end,
    keys = {
      {
        '<M-space>',
        function()
          local ls = require 'luasnip'
          if ls.expandable() then ls.expand() end
        end,
        mode = s 'nis',
        desc = 'expand luasnip snippet if possible'
      },

      {
        '<M-h>',
        function()
          local ls = require 'luasnip'
          if ls.jumpable(-1) then ls.jump(-1) end
        end,
        mode = s 'nis',
        desc = 'jump to previous luasnip node'
      },

      {
        '<M-l>',
        function()
          local ls = require 'luasnip'
          if ls.jumpable(1) then ls.jump(1) end
        end,
        mode = s 'nis',
        desc = 'jump to next luasnip node'
      },

      {
        '<M-j>',
        function()
          local ls = require 'luasnip'
          if ls.choice_active() then ls.change_choice(1) end
        end,
        mode = s 'nis',
        desc = 'cycle forwards through luasnip node choices'
      },

      {
        '<M-k>',
        function()
          local ls = require 'luasnip'
          if ls.choice_active() then ls.change_choice(-1) end
        end,
        mode = s 'nis',
        desc = 'cycle backwards through luasnip node choices',
      },
    },

  },
}
