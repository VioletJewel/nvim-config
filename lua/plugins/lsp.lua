local au = require 'utils'.augroup 'LspAttach'

local lsps = {
  clangd = {},

  zls = {},

  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
          return
        end
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

  vim.keymap.set('n', '<Space>K', 'K', {
    buffer = evt.buf,
    desc = 'preserve default K'
  })

  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
    buffer = evt.buf,
    desc = 'goto lsp implementation'
  })

  vim.keymap.set({ 'n', 'i', 'x' }, '<M-Tab>', function()
    local basewid = vim.api.nvim_get_current_win()
    for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if wid ~= basewid and vim.api.nvim_win_get_config(wid).win == basewid then
        vim.print(wid)
        vim.api.nvim_win_close(wid, false)
        return
      end
    end
    vim.lsp.buf.signature_help()
  end, {
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
    name = 'lspconfig',

    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },

    config = function()
      local lc = require 'lspconfig'

      vim.iter(pairs(lsps)):each(function(lsp, cfg)
        lc[lsp].setup(cfg)
      end)

      au { 'LspAttach', callback = lspCallback }
    end,

    keys = {
      {
        '<Leader>e',
        vim.diagnostic.open_float,
        desc = 'open diagnostic float'
      },

      {
        '[d',
        function() vim.diagnostic.jump { count = -1 } end,
        desc = 'goto prev diagnostic'
      },

      {
        ']d',
        function() vim.diagnostic.jump { count = 1 } end,
        desc = 'goto next diagnostic'
      },

      {
        '<Leader>q',
        vim.diagnostic.setloclist,
        desc = 'set diagnostic loclist'
      },
    },

  },

}
