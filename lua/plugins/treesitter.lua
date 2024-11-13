
local tsFts = {
  'markdown', 'c', 'cpp', 'make', 'lisp', 'haskell', 'ocaml', 'lua', 'vim',
  'query', 'json', 'json5', 'yaml', 'toml', 'rasi', 'elixir', 'heex',
  'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html', 'tex',
}

-- &ft to 0 or more tree-sitter grammars
local ft2ts = {
  -- additional ts grammars
  -- (if markdown not in tsFts above, ADD IT HERE)
  { 'regex' },
  -- ft -> ts grammars converstion
  markdown = { 'markdown', 'markdown_inline' },
  tex = { 'latex' },
  lisp = { 'commonlisp' },
  typescript = { 'typescript', 'tsx' },
  lua = { 'lua', 'luadoc' },
  vim = { 'vim', 'vimdoc' },
  javascriptreact = {},
  typescriptreact = {},
}

return {

  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require 'nvim-treesitter.install'.update { with_sync = true } ()
    end,
    event = { 'BufReadPost', 'BufNewFile' },
    ft = tsFts,
    config = function()
      local grammars = ft2ts[1] or {}
      local glen = #ft2ts
      for _, ft in ipairs(tsFts) do
        for _, g in ipairs(ft2ts[ft] or {ft}) do
          glen = glen + 1
          grammars[glen] = g
        end
      end
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = grammars,

        sync_install = false,

        highlight = { enable = true, },

        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<M-i>',
            node_incremental = '<M-i>',
            scope_incremental = '<M-I>',
            node_decremental = '<M-o>',
          },
        },

        matchup = {
          enable = true,
        },
      }
    end,
    cmd = {
      'TSInstall', 'TSInstallSync', 'TSInstallInfo',
      'TSUpdate', 'TSUpdateSync', 'TSUninstall',
      'TSBufEnable', 'TSBufDisable', 'TSBufToggle',
      'TSEnable', 'TSDisable', 'TSToggle',
      'TSModuleInfo', 'TSEditQuery', 'TSEditQueryUserAfter',
    },
    keys = {
      { '<M-i>', mode = { 'n', 'x' } },
      { '<M-i>', '<Esc><M-i>', mode = 'o' },
      { 'af', mode = { 'x', 'o' } }, { 'if', mode = { 'x', 'o' } },
      { 'ac', mode = { 'x', 'o' } }, { 'ic', mode = { 'x', 'o' } },
      '<M-a>', '<M-A>',
      { ']m', mode = { 'n', 'x', 'o' } }, { ']M', mode = { 'n', 'x', 'o' } },
      { '[m', mode = { 'n', 'x', 'o' } }, { '[M', mode = { 'n', 'x', 'o' } },
      { ']]', mode = { 'n', 'x', 'o' } }, { '][', mode = { 'n', 'x', 'o' } },
      { '[[', mode = { 'n', 'x', 'o' } }, { '[]', mode = { 'n', 'x', 'o' } },
      '<Leader>df', '<Leader>dF',
    }
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependecies = { 'nvim-treesitter/nvim-treesitter', },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<M-a>'] = '@parameter.inner',
            },
            swap_previous = {
              ['<M-A>'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<Leader>df'] = '@function.outer',
              ['<Leader>dF'] = '@class.outer',
            },
          },
        },
      }
    end,
    keys = {
      { 'af', mode = { 'x', 'o' }, ft = tsFts, },
      { 'if', mode = { 'x', 'o' }, ft = tsFts, },
      { 'ac', mode = { 'x', 'o' }, ft = tsFts, },
      { 'ic', mode = { 'x', 'o' }, ft = tsFts },
      { '<M-a>', ft = tsFts, }, { '<M-A>', ft = tsFts, },
      { '[m', ft = tsFts, }, { ']m', ft = tsFts, },
      { ']]', ft = tsFts, }, { '][', ft = tsFts, },
      { '[M', ft = tsFts, }, { ']M', ft = tsFts, },
      { '[[', ft = tsFts, }, { '[]', ft = tsFts, },
      { '<Leader>dF', ft = tsFts, }, { '<Leader>dF', ft = tsFts, },
    },
  },

  {
    'andymass/vim-matchup',
    lazy = false,
    -- event = { 'VeryLazy' },
    -- event = { 'BufReadPost', 'BufNewFile' },
    -- dependecies = { 'nvim-treesitter/nvim-treesitter', },
    -- config = function()
    --   require 'nvim-treesitter.configs'.setup { enable = true, }
    -- end,
  },

}
