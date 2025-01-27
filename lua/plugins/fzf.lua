local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {
  {-->
    'ibhagwan/fzf-lua',
    -- requires = {
    --   'nvim-tree/nvim-web-devicons' -- ./devicons.lua (opt)
    -- },
    cond = {
      keys('n', '<Bslash>f'),
      keys('n', '<Bslash>c'),
      keys('n', '<Bslash>C'),
      cmd 'FZF',
      cmd 'FzfLua',
    },
    config = function()
      require 'fzf-lua'.setup {
        { 'max-perf', 'border-fused' },
        winopts = {
          backdrop = os.getenv 'ASCIINEMA_REC' == '1' and 100 or nil,
          preview = {
            default = 'builtin',
            scrollbar = false,
            winopts = { number = false, },
            on_create = function()
              vim.wo.foldlevel = 0
              vim.wo.foldmethod = 'marker'
              vim.wo.number = true
            end,
          },
          treesitter = { enabled = true, },
        },
        previewers = {
          bat = {
            -- iff bat's config file exists, empty string; ellse '--color=always --style=changes
            args = vim.uv.fs_stat(vim.fs.joinpath((os.getenv 'XDG_CONFIG_DIR' or vim.fs.joinpath(os.getenv 'HOME', '.config')), 'bat', 'config')) and '' or '--color=always --style=changes',
          },
          builtin = {
            treesitter = {
              enabled = true,
            },
            extensions      = {
              ['png']       = { 'ueberzug' },
              ['svg']       = { 'ueberzug' },
              ['jpg']       = { 'ueberzug' },
            },
            ueberzug_scaler = "cover",
            render_markdown = { enabled = true, filetypes = { markdown = true } },
          },
        },
        -- files = {
        --   git_icons = true,
        --   file_icons = true,
        --   color_icons = false,
        -- },
        -- git = {
        --   files = {
        --     git_icons = true,
        --   },
        --   status = {
        --     git_icons = true,
        --   }
        -- },
        keymap = {
          builtin = {
            false,
            ['<M-Esc>'] = 'hide',
            ['<M-CR>'] = 'toggle-fullscreen',
            ['<F7>'] = 'toggle-preview-ts-ctx',
          },
          fzf = {
            true,
            -- ['alt-j']  = 'preview-down',
            -- ['alt-k']  = 'preview-up',
            -- ['alt-J'] = 'preview-page-down',
            -- ['alt-K'] = 'preview-page-up',
            ['alt-w']  = 'toggle-preview-wrap',
            ['alt-p']  = 'toggle-preview',
            ['alt-space']  = 'toggle+down',
          },
        },
        actions = {
          files = {
            true,
            ['alt-e'] = function(_, opts)
              local f = vim.fs.joinpath(opts.cwd, opts.last_query)
              local e = vim.api.nvim_replace_termcodes('<Esc>:e ', true, true, true)
              vim.api.nvim_feedkeys(e .. f, 'L', false)
            end,
          }
        },
      }
      vim.keymap.set('n', '<LocalLeader>f', function() require 'fzf-lua'.files() end, { desc = 'browse files in fzf' })
      vim.keymap.set('n', '<M-Esc>', function() require 'fzf-lua'.resume() end, { desc = 'resume fzf session' })
      vim.keymap.set('n', '<LocalLeader>c', function() require 'fzf-lua'.files { cwd = vim.fn.stdpath 'config' } end,
        { desc = 'browse nvim config files in fzf' })
      vim.keymap.set('n', '<LocalLeader>C',
        --- @diagnostic disable-next-line: param-type-mismatch
        function() require 'fzf-lua'.files { cwd = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugins') } end,
        { desc = 'browse nvim config files in fzf' })
    end,
  },--<
}
