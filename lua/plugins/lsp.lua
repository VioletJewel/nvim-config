local au = require 'utils'.augroup'LspAttach'

local lsps = vim.iter{
  clangd = {},

  zls = {},

  lua_ls = {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        return
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" --[["${3rd}/busted/library"]] }
        }
      })
    end,
    settings = { Lua = {} }
  },

  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        diagnostics = {
          enable = false,
        },
      }
    }
  },

}

-- global keymaps

vim.keymap.set('n', '<Leader>e', function()
  vim.diagnostic.open_float()
end, {
  desc = 'open diagnostic float'
})

vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump{ count = -1 }
end, {
  desc = 'goto prev diagnostic'
})

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump{ count = 1 }
end, {
  desc = 'goto next diagnostic'
})

vim.keymap.set('n', '<Leader>q', function() vim.diagnostic.setloclist() end, {
  desc = 'set diagnostic loclist'
})

local function lspCallback(evt)
  vim.bo[evt.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- buffer keymaps

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
    buffer = evt.buf,
    desc = 'goto lsp declaration'
  })

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
    buffer = evt.buf,
    desc = 'goto lsp definition'
  })

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
    buffer = evt.buf,
    desc = 'show lsp hover'
  })

  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
    buffer = evt.buf,
    desc = 'goto lsp implementation'
  })

  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {
    buffer = evt.buf,
    desc = 'show lsp signature help'
  })

  vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, {
    buffer = evt.buf,
    desc = 'add lsp workspace folder'
  })

  vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, {
    buffer = evt.buf,
    desc = 'remove lsp workspace folder'
  })

  vim.keymap.set('n', '<Leader>wl', function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, {
    buffer = evt.buf,
    desc = 'list lsp workspace folders'
  })

  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, {
    buffer = evt.buf,
    desc = 'goto lsp type definition'
  })

  vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, {
    buffer = evt.buf,
    desc = 'rename lsp symbol'
  })

  vim.keymap.set({ 'n', 'x' }, '<Leader>ca', vim.lsp.buf.code_action, {
    buffer = evt.buf,
    desc = 'list lsp code action'
  })

  vim.keymap.set('n', '<Leader>R', vim.lsp.buf.references, {
    buffer = evt.buf,
    desc = 'list lsp references'
  })

  vim.keymap.set({ 'n', 'x' }, '<Leader>F', function() vim.lsp.buf.format { async = true } end, {
    buffer = evt.buf,
    desc = 'format file|range using lsp'
  })
end

return {

  {
    'neovim/nvim-lspconfig',
    config = function()
      local lc = require 'lspconfig'

      lsps:each(function(lsp, cfg)
        lc[lsp].setup(cfg)
      end)

      au { 'LspAttach', callback = lspCallback }
    end
  },

}
