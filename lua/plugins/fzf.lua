local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)

return {

  {

    'ibhagwan/fzf-lua',

    dependencies = { 'nvim-tree/nvim-web-devicons' },

    opts = {
      'max-perf',
      previewers = {
        bat = {
          -- if bat's config file exists, empty string; else '--color=always --style=changes
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
    },

    keys = {
      {
        '<Leader>f',
        function() require'fzf-lua'.files() end,
        desc = 'browse files in fzf'
      },
      {
        '<M-Esc>',
        function() require'fzf-lua'.resume() end,
        desc = 'resume fzf session'
      },
      {
        '<LocalLeader>c',
        function() require'fzf-lua'.files{ cwd = vim.fn.stdpath 'config' } end,
        desc = 'browse nvim config files in fzf'
      },
    },

  },

}
