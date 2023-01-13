-- Author: Violet
-- Last Change: 12 January 2023

-- init {{{1

local lazypath = vim.fn.stdpath('config')..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- packags -- {{{1

local packages = {
  'rstacruz/vim-closer',
  'tpope/vim-commentary',
  'tommcdo/vim-exchange',
  'tpope/vim-fugitive',
  'neovim/nvim-lspconfig',
  'andymass/vim-matchup',
  'machakann/vim-sandwich',
  'tpope/vim-repeat',
  'vim-scripts/ReplaceWithRegister',
  'godlygeek/tabular',
  'folke/zen-mode.nvim',
  'junegunn/gv.vim',
  'L3MON4D3/LuaSnip',
  'novasenco/snap',
  'novasenco/vimix',
  'novasenco/nokto',
  'novasenco/vulpo',
  'lifepillar/gruvbox8',
  { 'preservim/vim-markdown', ft='markdown' },

  'dylnmc/ctrlg.vim',

  'ibhagwan/fzf-lua',

  -- 'junegunn/fzf',
  -- { 'junegunn/fzf.vim', as='fzf.vim' },

  -- TODO: https://github.com/windwp/nvim-autopairs

  -- { 'tpope/vim-markdown', ft='markdown' },
  { 'nvim-treesitter/nvim-treesitter',
    build = function() -- {{{2
      local ts_update = require'nvim-treesitter.install'.update{with_sync=true}
      ts_update()
    end,
    config = function() -- {{{2
      if TreesitterInstalled then return end -- in case this file re-sourced
      local ok, treecfg = pcall(require, 'nvim-treesitter.configs')
      if not ok then return end
      treecfg.setup {
        -- "all", "maintained", or a list of languages
        ensure_installed = { 'c', 'cpp', 'make', 'bash', 'vim', 'lua',
        'json', 'yaml', 'toml' },
        -- ensure_installed = { 'c', 'cpp', 'make', 'bash', 'html', 'css',
        --   'typescript', 'regex', 'json', 'json5', 'bibtex', 'haskell',
        --   'ocaml', 'vim', 'commonlisp', 'rasi', 'yaml', 'toml' },
        sync_install = false,
        -- ignore_install = {},
        highlight = {
          enable = true,
          -- disable = {},
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
      }
      TreesitterInstalled = true
    end -- }}}2
  }
}

local optional_packages = { -- {{{1
  'tpope/vim-abolish',
  'junegunn/goyo.vim',
  'tweekmonster/helpful.vim',
  'nvim-treesitter/playground',
  'puremourning/vimspector',
  'novasenco/ptppt.vim',

  { 'dhruvasagar/vim-table-mode', ft='tex' },
  { 'KeitaNakamura/tex-conceal.vim', ft='tex' },

  { 'nvim-telescope/telescope.nvim',
      dependencies={'nvim-lua/plenary.nvim'},
      config = function()
        require'telescope'.setup()
      end
  },

  -- { 'glacambre/firenvim', build=function() vim.fn['firenvim#install'](0) end },
  -- { 'lervag/vimtex', ft={'tex'}, tag='v1.6' },
}

local opts = { -- {{{1
  root = vim.fn.stdpath('config')..'/lazy'
}

-- setup {{{1

-- add optional_packages into packages
for ind, name in ipairs(optional_packages) do
  local pkg
  if type(name) == 'table' then
    pkg = name
    name = pkg[1]
  else
    pkg = {name}
  end
  pkg.lazy = true
  table.insert(packages, pkg)
end

-- iterate over packages and remove /^n?vim[-.]/ and /[-.]n\?vim$/
for ind, name in ipairs(packages) do
  local pkg
  if type(name) == 'table' then
    pkg = name
    name = pkg[1]
  else
    pkg = {name}
  end
  local sname = name:sub(name:find'/'+1, -1)
  local ssname = sname:gsub('[.-]n?vim$', ''):gsub('^n?vim[.-]', '')
  if pkg.as == nil and sname ~= ssname then
    pkg.name = ssname
  end
  packages[ind] = pkg
end

require'lazy'.setup(packages, opts)

