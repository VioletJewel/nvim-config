local s = function(modes) return vim.split(modes, '') end
local map = vim.keymap.set

return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = 'make install_jsregexp',
    config = function()

      -- setup

      local cfg = vim.fn.stdpath'config'
      if type(cfg) == 'table' then cfg = cfg[1] end
      local ls = require'luasnip'

      -- maps

      map(s'nis', '<M-space>', function()
        if ls.expandable() then ls.expand() end
      end, {
          desc = 'expand luasnippet'
        }
      )

      map(s'nis', '<M-h>', function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, {
          desc = 'jump to previous luasnip node'
        }
      )

      map(s'nis', '<M-l>', function()
        if ls.jumpable(1) then ls.jump(1) end
      end, {
          desc = 'jump to next luasnip node'
        })

      map(s'nis', '<M-j>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end, {
          desc = 'cycle forward through luasnip node choices'
        }
      )

      map(s'nis', '<M-k>', function()
        if ls.choice_active() then ls.change_choice(-1) end
      end, {
          desc = 'cycle backwards through luasnip node choices',
        }
      )

      -- lazy snippet loading

      require'luasnip.loaders.from_lua'.lazy_load{
        lazy_paths = vim.fs.joinpath(cfg, 'snippets')
      }

    end
  },
}
