-- Author: Violet
-- Last Change: 12 April 2023

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

setup('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', },
      diagnostics = { globals = {'vim'}, disable = { 'lowercase-global' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      telemetry = { enable = false, },
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

-- python {{{1

setup'pyright'

-- }}}1

return true

