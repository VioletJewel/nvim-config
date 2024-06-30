return {

  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require 'nvim-treesitter.install'.update { with_sync = true } ()
    end,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'markdown', -- required
          'c', 'cpp', 'make',
          'commonlisp', 'haskell', 'ocaml',
          'lua', 'luadoc', 'vim', 'vimdoc', 'query', 'regex',
          'json', 'json5', 'yaml', 'toml', 'rasi',
          'elixir', 'heex', 'javascript', 'html',
        },
        sync_install = false,
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<M-n>",
            node_incremental = "<M-n>",
            scope_incremental = "<M-N>",
            node_decremental = "<M-BS>",
          },
        },
        indent = { enable = true },
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'nvim-treesitter/playground',
    optional = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        }
      }
    end
  },

}
