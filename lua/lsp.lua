-- Author: Violet
-- Last Change: 12 January 2023

-- set up lsp via lspconfig

local lsploaded, lspconfig = pcall(require, 'lspconfig')
if not lsploaded then return false end

local map = require'utils'.map

-- global keymaps {{{1

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map{ '<leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>', silent=true }
map{ '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', silent=true }
map{ ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', silent=true }
map{ '<leader>D', '<cmd>lua vim.diagnostic.setloclist()<cr>', silent=true }

-- lsp setup {{{1

local function on_attach(_, bnr)
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer

  vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- TODO

  local function m(l, c) map{ l, '<cmd>lua '..c..'<cr>', silent=true, buffer=bnr } end
  m( 'gD',     'vim.lsp.buf.declaration()' )
  m( 'gd',     'vim.lsp.buf.definition()' )
  m( 'K',      'vim.lsp.buf.hover()' )
  m( '<L>i',   'vim.lsp.buf.implementation()' )
  m( '<c-k>',  'vim.lsp.buf.signature_help()' )
  m( '<L>wa',  'vim.lsp.buf.add_workspace_folder()' )
  m( '<L>wr',  'vim.lsp.buf.remove_workspace_folder()' )
  m( '<L>wl',  'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))' )
  m( '<L>td',  'vim.lsp.buf.type_definition()' )
  m( '<L>r',   'vim.lsp.buf.rename()' )
  m( '<L>a',   'vim.lsp.buf.code_action()' )
  m( '<LL>gr', 'vim.lsp.buf.references()' )
  m( '<LL>gf', 'vim.lsp.buf.formatting()' )
  map{ '<L>K', 'K' }
end

local function setup(name, cfg)
  if not cfg then cfg = {} end
  cfg.on_attach = on_attach
  lspconfig[name].setup(cfg)
end


-- c {{{1

-- setup'clangd'
setup'ccls'

-- lua {{{1

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

setup('sumneko_lua', {
  on_new_config = function(cfg, root)
    if root == os.getenv'HOME'..'/.config/awesome' then
      cfg.settings.Lua.diagnostics.globals = {'awesome', 'tag', 'client', 'screen'}
    elseif root == os.getenv'HOME'..'/.config/nvim' then
      cfg.settings.Lua.diagnostics.globals = {'vim'}
    end
  end,
  cmd = { os.getenv'HOME'..'/git/lua-language-server/bin/lua-language-server' },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- globals = {'vim', 'awesome', 'tag'},
        disable = {'lowercase-global'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- vim {{{1

setup('vimls', {
  diagnostic = { enable = true },
  indexes = {
    projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
    runtimepath = true,
  },
  iskeyword = "@,48-57,_,192-255,-#",
  runtimepath = "",
  suggest = {
    fromRuntimepath = true,
    fromVimruntime = true
  },
  vimruntime = ""
})

-- }}}1

return true

