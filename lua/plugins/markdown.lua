return {

  {
    'dhruvasagar/vim-table-mode',
    name = 'table-mode',
    ft = 'markdown',
  },

  {
    'iamcco/markdown-preview.nvim',
    name = 'markdown-preview',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_auto_close = 0
    end,
    ft = 'markdown',
  },

  {
    'toppair/peek.nvim',
    name = 'peek',
    build = 'deno task --quiet build:fast',
    config = function()
      require 'peek'.setup {
        -- app = 'firefox'
      }
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
    cmd = { 'PeekOpen', 'PeekClose' },
    ft = 'markdown',
  },


  {
    'MeanderingProgrammer/render-markdown.nvim',
    name = 'render-markdown',
    ft = 'markdown',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    opts = {
      enabled = false,
      preset = 'lazy',
      anti_conceal = { enabled = false },
      render_modes = { 'n', 'v', 'i', 'c' },
      heading = {
        position = 'overlay',
        sign = true,
        -- signs = { '󰫎 ' },
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        width = 'full',
        border = true,
        border_prefix = false,
        above = '▄',
        below = '▀',
      },
      bullet = {
        left_pad = 0,
        right_pad = 0,
      },
      checkbox = {
        enabled = true,
        position = 'inline',
        custom = {
          todo = {
            raw = '[-]',
            rendered = '󰥔 ',
            highlight = 'RenderMarkdownTodo',
            scope_highlight = 'RenderMarkdownTodo',
          },
          fail = {
            raw = '[/]',
            rendered = ' ',
            highlight = 'RenderMarkdownError',
            scope_highlight = 'RenderMarkdownError',
          }
        },
      },
      -- indent = {
      --   enabled = true,
      --   per_level = 2,
      --   skip_level = 0,
      --   skip_heading = true,
      -- },
      win_options = {
        conceallevel = {
          default = 3,
          rendered = 3,
        },
        concealcursor = {
          default = '',
          rendered = 'nvic',
        },
      },
      -- latex = {
      --   enabled = true,
      --   converter = 'latex2text',
      --   highlight = 'RenderMarkdownMath'
      -- },
      -- code = {
      --   enabled = true,
      --   sign = true,
      --   width = 'full',
      -- },
      -- dash = {
      --   enabled = true,
      --   icon = '─',
      --   width = 'full',
      -- }
    },
  },

  -- {
  --   'preservim/vim-markdown',
  --   init = function()
  --     vim.g.vim_markdown_override_foldtext = 0
  --     vim.g.vim_markdown_no_default_key_mappings = 1
  --     vim.g.vim_markdown_folding_disabled = 1
  --   end
  -- },

}
