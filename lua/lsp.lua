-- Author: Violet
-- Last Change: 10 September 2023

-- set up lsp via lspconfig

local lsploaded, lspconfig = pcall(require, 'lspconfig')
if not lsploaded then return false end

local mapall = require'utils'.mapall

-- global keymaps {{{1

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
mapall{
  '<sil> <l>d <cmd>lua vim.diagnostic.open_float()<cr>',
  '<sil> [d   <cmd>lua vim.diagnostic.goto_prev()<cr>',
  '<sil> ]d   <cmd>lua vim.diagnostic.goto_next()<cr>',
  '<sil> <l>D <cmd>lua vim.diagnostic.setloclist()<cr>',
}

-- lsp setup {{{1

local function lspfmt(a)
  local k, n = a:match'^(%S+)%s+(.*)'
  return { k, vim.lsp.buf[n], buffer=true, silent=true, desc='lsp.'..n }
end

local bufmaps = {
  lspfmt'gD    declaration',
  lspfmt'gd    definition',
  lspfmt'K     hover',
  lspfmt'<L>i  implementation',
  lspfmt'<c-k> signature_help',
  lspfmt'<L>wa add_workspace_folder',
  lspfmt'<L>wr remove_workspace_folder',
  lspfmt'<L>ws workspace_symbol',
  { '<buf> <L>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end, buffer=true, silent=true },
  lspfmt'td    type_definition',
  lspfmt'<L>r  rename',
  lspfmt'<L>ca code_action',
  lspfmt'<L>gr references',
  lspfmt'<L>gf format',
  '<sil,buf> <L>K K',
}

local function on_attach(_, bnr)
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer

  vim.api.nvim_buf_set_option(bnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  mapall(bufmaps)

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

