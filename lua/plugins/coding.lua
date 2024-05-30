
return {
  'tpope/vim-commentary',
  'rstacruz/vim-closer',
  'tpope/vim-fugitive',
  'junegunn/gv.vim',

  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require'nvim-surround'.setup{}
    end,
  },

  {
    'dhruvasagar/vim-table-mode',
    lazy = true,
    ft = 'tex',
  },

  {
    'KeitaNakamura/tex-conceal.vim',
    lazy = true,
    ft = 'tex',
  },

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
      vim.tbl_map(require'utils'.map, {
        { 'i <M-Space>', function() ls.expand() end },
        { 'is <M-j>', function() ls.jump( 1) end },
        { 'is <M-k>', function() ls.jump(-1) end },
        { 'is <M-;>', function() if ls.choice_active() then ls.change_choice(1) end end },
      })
      -- lazy snippet loading
      require'luasnip.loaders.from_lua'.lazy_load{
        lazy_paths = vim.fs.joinpath(cfg, 'snippets')
      }
    end
  },

  {
    'lervag/vimtex',
    config = function()
      vim.g.vimtex_view_general_viewer = 'zathura'
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = function() return './.'..vim.fn.expand'%:t:r'..'.out' end,
        out_dir = function() return './.'..vim.fn.expand'%:t:r'..'.out' end,
        options = {
          '-shell-escape',
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-emulate-aux-dir',
          '-interaction=nonstopmode',
        },
      }
    end
  },

}

