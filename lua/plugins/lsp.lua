
local lsps = {}

lsps.clangd = {}

lsps.lua_ls = { -- {{{
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, '${3rd}/luv/library' },
      },
      diagnostics = { globals = { 'vim' } }
    },
  }
} -- }}}

local lspMaps = { -- {{{
  {'n <L>e', desc='vim.diagnostic.open_float', vim.diagnostic.open_float},
  {'n [d',   desc='vim.diagnostic.goto_prev', vim.diagnostic.goto_prev},
  {'n ]d',   desc='vim.diagnostic.goto_next', vim.diagnostic.goto_next},
  {'n <L>q', desc='vim.diagnostic.setloclist', vim.diagnostic.setloclist},
} -- }}}

local lspBufMaps = {
  {'n gD',     desc='vim.lsp.buf.declaration', vim.lsp.buf.declaration},
  {'n gd',     desc='vim.lsp.buf.definition', vim.lsp.buf.definition},
  {'n K',      desc='vim.lsp.buf.hover', vim.lsp.buf.hover},
  {'n gi',     desc='vim.lsp.buf.implementation', vim.lsp.buf.implementation},
  {'n <C-k>',  desc='vim.lsp.buf.signature_help', vim.lsp.buf.signature_help},
  {'n <L>wa',  desc='vim.lsp.buf.add_workspace_folder', vim.lsp.buf.add_workspace_folder},
  {'n <L>wr',  desc='vim.lsp.buf.remove_workspace_folder', vim.lsp.buf.remove_workspace_folder},
  {'n <L>wl',  desc='vim.lsp.buf.list_workspace_folders', function() vim.print(vim.lsp.buf.list_workspace_folders()) end },
  {'n <L>D',   desc='vim.lsp.buf.type_definition', vim.lsp.buf.type_definition},
  {'n <L>r',   desc='vim.lsp.buf.rename', vim.lsp.buf.rename},
  {'nv <L>ca', desc='vim.lsp.buf.code_action', vim.lsp.buf.code_action},
  {'n <L>R',   desc='vim.lsp.buf.references', vim.lsp.buf.references},
  {'n <L>f',   desc='vim.lsp.buf.format', function() vim.lsp.buf.format{async=true} end},
}


return {

  {
    'neovim/nvim-lspconfig',
    config = function()
      local lc = require'lspconfig'
      for lsp, cfg in pairs(lsps) do
        lc[lsp].setup(cfg)
      end

      vim.tbl_map(require'utils'.map, lspMaps)

      local au = require'utils'.augroup('LspAttach')
      au('LspAttach', {
        callback = function(evt)
          local function bmap(t)
            require'utils'.map(vim.tbl_extend('keep', t, {buffer=evt.buf}))
          end
          vim.bo[evt.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          vim.tbl_map(bmap, lspBufMaps)
        end
      })

    end
  },

}

