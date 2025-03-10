-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {

  {-->
    'nvim-treesitter/nvim-treesitter',
    cond = event 'UIEnter',
    run = function() require 'nvim-treesitter.install'.update { with_sync = true } () end,
    config = function()
      -- &ft to 0 or more tree-sitter grammars
      local ft2ts = {
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
      local grammars = ft2ts[1] or {}
      local glen = #ft2ts
      for _, ft in ipairs {
        'markdown', 'c', 'cpp', 'make', 'lisp', 'haskell', 'ocaml', 'lua', 'vim',
        'query', 'json', 'json5', 'yaml', 'toml', 'rasi', 'elixir', 'heex',
        'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html', 'tex',
        'norg', 'org',
      } do
        for _, g in ipairs(ft2ts[ft] or { ft }) do
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
          disable_virtual_text = true,
        },
      }
    end,
  },--<

  {-->
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = { 'nvim-treesitter/nvim-treesitter', },
    cond = event { 'BufReadPost', 'BufNewFile' },
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
  },--<

  {-->
    'nvim-treesitter/nvim-treesitter-context',
    cond = event { 'BufReadPost', 'BufNewFile' },
    config = function()
      require 'treesitter-context'.setup {
        trim_scope = 'inner',
        max_lines = 2,
        mode = 'topline',
      }
    end,
  },--<


  -- {-->
  --   'theHamsta/nvim-treesitter-pairs',
  --   cond = event { 'BufReadPost', 'BufNewFile' },
  --   config = function()
  --     require'nvim-treesitter.configs'.setup {
  --       pairs = {
  --         enable = true,
  --       }
  --     }
  --   end,
  -- },--<

}
