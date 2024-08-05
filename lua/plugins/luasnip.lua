local s = function(modes) return vim.split(modes, '') end

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

      vim.keymap.set(s'nis', '<M-space>', function()
        if ls.expandable() then ls.expand() end
      end, {
          desc = 'expand luasnip snippet if possible'
        }
      )

      vim.keymap.set(s'nis', '<M-h>', function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, {
          desc = 'jump to previous luasnip node'
        }
      )

      vim.keymap.set(s'nis', '<M-l>', function()
        if ls.jumpable(1) then ls.jump(1) end
      end, {
          desc = 'jump to next luasnip node'
        })

      vim.keymap.set(s'nis', '<M-j>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end, {
          desc = 'cycle forwards through luasnip node choices'
        }
      )

      vim.keymap.set(s'nis', '<M-k>', function()
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
