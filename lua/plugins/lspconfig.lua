-- local event = require 'pckr.loader.event'

local lsps = { -->1
  clangd = {},
  zls = {},
  marksman = {},
  lua_ls = { -->2
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
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
  rust_analyzer = { -->2
    -- settings = {
    --   ['rust-analyzer'] = {
    --     diagnostics = { enable = false, },
    --   }
    -- }
  },
}

local function lspBufSetup(evt) -->1
  local bnr = evt.buf
  local function bmap(mode, lhs, rhs, opts)
    if type(opts) == 'string' then opts = { desc = opts } end
    opts.buffer = opts.buffer or bnr
    vim.keymap.set(
      type(mode) == 'table' and mode or vim.split(mode, ''),
      lhs,
      type(rhs) == 'string' and vim.lsp.buf[rhs] or rhs,
      opts
    )
  end

  vim.bo[bnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  bmap('n', 'gD', 'declaration', 'goto lsp declaration')
  bmap('n', 'gd', 'definition', 'goto lsp definition')
  bmap('n', 'K', 'hover', 'show lsp hover')
  bmap('n', '<Space>K', 'K', 'preserve default K')
  bmap('n', 'gi', 'implementation', 'goto lsp implementation')
  bmap('nix', '<M-s>', function()
    local basewid = vim.api.nvim_get_current_win()
    for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if wid ~= basewid and vim.api.nvim_win_get_config(wid).win == basewid then
        vim.api.nvim_win_close(wid, false)
        return
      end
    end
    vim.lsp.buf.signature_help()
  end, 'show lsp signature help')
  bmap('n', '<Leader>wa', 'add_workspace_folder', 'add lsp workspace folder')
  bmap('n', '<Leader>wr', 'remove_workspace_folder', 'remove lsp workspace folder')
  bmap('n', '<Leader>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end, 'list lsp workspace folders')
  bmap('n', '<Leader>D', 'type_definition', 'goto lsp type definition')
  bmap('n', '<Leader>r', 'rename', 'rename lsp symbol')
  bmap('nx', '<Leader>ca', 'code_action', 'list lsp code action')
  bmap('n', '<Leader>R', 'references', 'list lsp references')
  bmap({ 'n', 'x' }, '<Leader>F', function() vim.lsp.buf.format { async = true } end, 'format file|range using lsp')
end --<1

return {

  {
    'neovim/nvim-lspconfig',
    -- cond = event { 'BufReadPost', 'BufNewFile' },
    start = true,
    config = function()
      local lc = require 'lspconfig'
      local au = require 'utils'.augroup 'LspAttach'

      vim.iter(pairs(lsps)):each(function(lsp, cfg)
        lc[lsp].setup(cfg)
      end)
      au { 'LspAttach', callback = lspBufSetup }

      -- global keymaps

      vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = 'open diagnostic float' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'goto prev diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'goto next diagnostic' })
      vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, { desc = 'set diagnostic loclist' })
    end,
  }

}