return {

  {
    'OXY2DEV/markview.nvim',
    cond = Event 'UIEnter',
    config = function()
      require 'markview'.setup {
        preview = { icon_provider = 'devicons' },

        markdown_inline = {
          checkboxes = {
              enable = true,

              checked = { text = "󰗠 ", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
              unchecked = { text = "󰄰 ", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },

              ["/"] = { text = "󱎖 ", hl = "MarkviewCheckboxPending" },
              [">"] = { text = " ", hl = "MarkviewCheckboxCancelled" },
              ["<"] = { text = "󰃖 ", hl = "MarkviewCheckboxCancelled" },
              ["-"] = { text = "󰍶 ", hl = "MarkviewCheckboxCancelled", scope_hl = "MarkviewCheckboxStriked" },

              ["?"] = { text = "󰋗 ", hl = "MarkviewCheckboxPending" },
              ["!"] = { text = "󰀦 ", hl = "MarkviewCheckboxUnchecked" },
              ["*"] = { text = "󰓎 ", hl = "MarkviewCheckboxPending" },
              ['"'] = { text = "󰸥 ", hl = "MarkviewCheckboxCancelled" },
              ["l"] = { text = "󰆋 ", hl = "MarkviewCheckboxProgress" },
              ["b"] = { text = "󰃀 ", hl = "MarkviewCheckboxProgress" },
              ["i"] = { text = "󰰄 ", hl = "MarkviewCheckboxChecked" },
              ["S"] = { text = " ", hl = "MarkviewCheckboxChecked" },
              ["I"] = { text = "󰛨 ", hl = "MarkviewCheckboxPending" },
              ["p"] = { text = " ", hl = "MarkviewCheckboxChecked" },
              ["c"] = { text = " ", hl = "MarkviewCheckboxUnchecked" },
              ["f"] = { text = "󱠇 ", hl = "MarkviewCheckboxUnchecked" },
              ["k"] = { text = " ", hl = "MarkviewCheckboxPending" },
              ["w"] = { text = " ", hl = "MarkviewCheckboxProgress" },
              ["u"] = { text = "󰔵 ", hl = "MarkviewCheckboxChecked" },
              ["d"] = { text = "󰔳 ", hl = "MarkviewCheckboxUnchecked" },
          },
          emails = {
            ['%@proton.me$'] = {
              icon = '⚛ ',
              hl = 'MarkviewPalette6Fg',
            }
          }
        },
      }
    end
  },

  -- {
  --   'dhruvasagar/vim-table-mode',
  --   cond = Event('FileType', 'markdown'),
  -- },

  -- {
  --   'iamcco/markdown-preview.nvim',
  --   run = 'cd app && yarn install',
  --   cond = Event('FileType', 'markdown'),
  --   config_pre = function()
  --     vim.g.mkdp_auto_close = 0
  --   end,
  -- },

  -- {
  --   'toppair/peek.nvim',
  --   run = 'deno task --quiet build:fast',
  --   cond = {
  --     Cmd 'PeekOpen',
  --     Cmd 'PeekClose',
  --   },
  --   config = function()
  --     require 'peek'.setup {
  --       -- app = 'firefox'
  --     }
  --     vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
  --     vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
  --   end,
  -- },

  -- {
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   requires = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-tree/nvim-web-devicons'
  --   },
  --   cond = Event('FileType', 'markdown'),
  --   config = function()
  --     require 'render-markdown'.setup {
  --       enabled = true,
  --       preset = 'lazy',
  --       anti_conceal = { enabled = false },
  --       render_modes = { 'n', 'v', 'i', 'c' },
  --       heading = {
  --         position = 'overlay',
  --         sign = false,
  --         -- signs = { '󰫎 ' },
  --         icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
  --         width = 'full',
  --         border = true,
  --         border_prefix = false,
  --         above = '▄',
  --         below = '▀',
  --       },
  --       bullet = {
  --         left_pad = 0,
  --         right_pad = 0,
  --       },
  --       checkbox = {
  --         enabled = true,
  --         position = 'inline',
  --         custom = {
  --           todo = {
  --             raw = '[-]',
  --             rendered = '󰥔 ',
  --             highlight = 'RenderMarkdownTodo',
  --             scope_highlight = 'RenderMarkdownTodo',
  --           },
  --           fail = {
  --             raw = '[/]',
  --             rendered = ' ',
  --             highlight = 'RenderMarkdownError',
  --             scope_highlight = 'RenderMarkdownError',
  --           }
  --         },
  --       },
  --       -- indent = {
  --       --   enabled = true,
  --       --   per_level = 2,
  --       --   skip_level = 0,
  --       --   skip_heading = true,
  --       -- },
  --       win_options = {
  --         conceallevel = {
  --           default = 3,
  --           rendered = 3,
  --         },
  --         concealcursor = {
  --           default = '',
  --           rendered = 'nvic',
  --         },
  --       },
  --       latex = {
  --         enabled = true,
  --         converter = 'latex2text',
  --         highlight = 'RenderMarkdownMath'
  --       },
  --       code = {
  --         enabled = true,
  --         sign = false,
  --         width = 'full',
  --       },
  --       -- dash = {
  --       --   enabled = true,
  --       --   icon = '─',
  --       --   width = 'full',
  --       -- }
  --     }
  --   end,
  -- },

  -- { 'zk-org/zk-nvim',
  --   config = function()
  --     require 'zk'.setup()
  --   end,
  -- };

}
