local au = require 'utils'.augroup'LspAttach'
local map = vim.keymap.set

local lsps = vim.iter{
  clangd = {},

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

  rls = {
    settings = {
      rust = {
        unstable_features = true,
        build_on_save = false,
        all_features = true,
      },
    },
  },
}

-- global keymaps

map('n', '<Leader>e', function()
  vim.diagnostic.open_float()
end, {
  desc = 'diagnostic open_float'
})

map('n', '[d', function()
  vim.diagnostic.jump{ count = -1 }
end, {
  desc = 'diagnostic goto_prev'
})

map('n', ']d', function()
  vim.diagnostic.jump{ count = 1 }
end, {
  desc = 'diagnostic goto_next'
})

map('n', '<Leader>q', function() vim.diagnostic.setloclist() end, {
  desc = 'diagnostic setloclist'
})

local function lspCallback(evt)
  vim.bo[evt.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

  -- buffer keymaps

  map('n', 'gD', vim.lsp.buf.declaration, {
    buffer = evt.buf,
    desc = 'lsp declaration'
  })

  map('n', 'gd', vim.lsp.buf.definition, {
    buffer = evt.buf,
    desc = 'lsp definition'
  })

  map('n', 'K', vim.lsp.buf.hover, {
    buffer = evt.buf,
    desc = 'lsp hover'
  })

  map('n', 'gi', vim.lsp.buf.implementation, {
    buffer = evt.buf,
    desc = 'lsp implementation'
  })

  map('n', '<C-k>', vim.lsp.buf.signature_help, {
    buffer = evt.buf,
    desc = 'lsp signature_help'
  })

  map('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, {
    buffer = evt.buf,
    desc = 'lsp add_workspace_folder'
  })

  map('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, {
    buffer = evt.buf,
    desc = 'lsp remove_workspace_folder'
  })

  map('n', '<Leader>wl', function()
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, {
    buffer = evt.buf,
    desc = 'lsp list_workspace_folders'
  })

  map('n', '<Leader>D', vim.lsp.buf.type_definition, {
    buffer = evt.buf,
    desc = 'lsp type_definition'
  })

  map('n', '<Leader>r', vim.lsp.buf.rename, {
    buffer = evt.buf,
    desc = 'lsp rename'
  })

  map({ 'n', 'x' }, '<Leader>ca', vim.lsp.buf.code_action, {
    buffer = evt.buf,
    desc = 'lsp code_action'
  })

  map('n', '<Leader>R', vim.lsp.buf.references, {
    buffer = evt.buf,
    desc = 'lsp references'
  })

  map({ 'n', 'x' }, '<Leader>F', function() vim.lsp.buf.format { async = true } end, {
    buffer = evt.buf,
    desc = 'lsp format'
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
