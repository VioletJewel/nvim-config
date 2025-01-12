local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {

  {
    'dhruvasagar/vim-table-mode',
    cond = event('FileType', 'markdown'),
  },

  {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    cond = event('FileType', 'markdown'),
    config_pre = function()
      vim.g.mkdp_auto_close = 0
    end,
  },

  {
    'toppair/peek.nvim',
    run = 'deno task --quiet build:fast',
    cond = {
      cmd 'PeekOpen',
      cmd 'PeekClose',
    },
    config = function()
      require 'peek'.setup {
        -- app = 'firefox'
      }
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    cond = event('FileType', 'markdown'),
    config = function()
      require 'render-markdown'.setup {
        enabled = true,
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
        latex = {
          enabled = true,
          converter = 'latex2text',
          highlight = 'RenderMarkdownMath'
        },
        code = {
          enabled = true,
          sign = true,
          width = 'full',
        },
        -- dash = {
        --   enabled = true,
        --   icon = '─',
        --   width = 'full',
        -- }
      }
    end,
  },

  -- { 'zk-org/zk-nvim',
  --   config = function()
  --     require 'zk'.setup()
  --   end,
  -- };

}
