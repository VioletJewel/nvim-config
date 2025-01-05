local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'

return {
  { 'ibhagwan/fzf-lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    cond = {
      keys('n', '<Space>f'),
      keys('n', '<Bslash>c'),
      cmd 'FZF',
      cmd 'FzfLua',
    },
    config = function()
      require 'fzf-lua'.setup {
        'max-perf',
        previewers = {
          bat = {
            -- iff bat's config file exists, empty string; ellse '--color=always --style=changes
            args = vim.uv.fs_stat(vim.fs.joinpath((os.getenv 'XDG_CONFIG_DIR' or vim.fs.joinpath(os.getenv 'HOME', '.config')), 'bat', 'config')) and '' or '--color=always --style=changes',
          }
        },
        keymap = {
          builtin = {
            true,
            ['<M-f>'] = 'toggle-fullscreen',
          },
          fzf = {
            true,
            ['alt-j']  = 'preview-down',
            ['alt-k']  = 'preview-up',
            ['ctrl-j'] = 'preview-page-down',
            ['ctrl-k'] = 'preview-page-up',
            ['alt-w']  = 'toggle-preview-wrap',
            ['alt-p']  = 'toggle-preview',
          },
        },
        actions = {
          files = {
            true,
            ['alt-e'] = function(_, opts)
              local f = vim.fs.joinpath(opts.cwd, opts.last_query)
              local e = vim.api.nvim_replace_termcodes('<Esc>:e ', true, true, true)
              vim.api.nvim_feedkeys(e..f, 'L', false)
            end,
          }
        },
      }
      vim.keymap.set('n', '<Leader>f', function() require'fzf-lua'.files() end, { desc = 'browse files in fzf' })
      vim.keymap.set('n', '<M-Esc>', function() require'fzf-lua'.resume() end, { desc = 'resume fzf session' })
      vim.keymap.set('n', '<LocalLeader>c', function() require'fzf-lua'.files{ cwd = vim.fn.stdpath 'config' } end, { desc = 'browse nvim config files in fzf' })
    end,
  };
}
