return {

  {
    'tpope/vim-fugitive',
    lazy = true,
  },
  {
    'junegunn/gv.vim',
    lazy = true,
  },

  {
    'NeogitOrg/neogit',
    opts = {
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',      -- optional
      -- 'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua',            -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signcolumn = false, -- Toggle w :Gitsigns toggle_signs
      -- numhl      = false, -- Toggle w :Gitsigns toggle_numhl
      -- linehl     = false, -- Toggle w :Gitsigns toggle_linehl
      -- word_diff  = false, -- Toggle w :Gitsigns toggle_word_diff
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        -- Navigation
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk 'next'
          end
        end, {
          buffer = bufnr,
          desc = 'go to next git hunk'
        })

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk 'prev'
          end
        end, {
          buffer = bufnr,
          desc = 'go to previous git hunk'
        })

        -- Actions

        vim.keymap.set('n',
          '<Leader>hs', gitsigns.stage_hunk, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n',
          '<Leader>hr', gitsigns.reset_hunk, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('x', '<Leader>hs', function() gitsigns.stage_hunk {
          vim.fn.line('.'), vim.fn.line('v') } end, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('x', '<Leader>hr', function() gitsigns.reset_hunk {
          vim.fn.line('.'), vim.fn.line('v') } end, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hS', gitsigns.stage_buffer, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hu', gitsigns.undo_stage_hunk, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hR', gitsigns.reset_buffer, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hp', gitsigns.preview_hunk, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hb', function()
          gitsigns.blame_line { full = true }
        end, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>tb', gitsigns.toggle_current_line_blame, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hd', gitsigns.diffthis, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>hD', function() gitsigns.diffthis('~') end, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        vim.keymap.set('n', '<Leader>td', gitsigns.toggle_deleted, {
          buffer = bufnr,
          desc = 'stage gitsigns hunk'
        })

        -- toggle signs

        local function toggle(desc, func)
          return function() print(desc..' '..(func() and 'on' or 'off')) end
        end

        vim.keymap.set('n', '<Leader>gss', toggle('sign-column signs', gitsigns.toggle_signs), {
          buffer = bufnr,
          desc = 'toggle gitsigns sign-column signs'
        })

        vim.keymap.set('n', '<Leader>gsn', toggle('linenr highlight', gitsigns.toggle_numhl), {
          buffer = bufnr,
          desc = 'toggle gitsigns linenr highlight'
        })

        vim.keymap.set('n', '<Leader>gsl', toggle('inline highlight', gitsigns.toggle_linehl), {
          buffer = bufnr,
          desc = 'toggle gitsigns inline highlight'
        })

        vim.keymap.set('n', '<Leader>gsw', toggle('word diff', gitsigns.toggle_word_diff), {
          buffer = bufnr,
          desc = 'toggle gitsigns word diff'
        })

        vim.keymap.set('n', '<Leader>gsb', toggle('auto git blame', gitsigns.toggle_current_line_blame), {
          buffer = bufnr,
          desc = 'toggle gitsigns auto git blame'
        })

        -- git blame

        vim.keymap.set('n', '<Leader>gb', gitsigns.blame_line, {
          buffer = bufnr,
          desc = 'show git blame on current line'
        })

        vim.keymap.set('n', '<Leader>gB', gitsigns.blame, {
          buffer = bufnr,
          desc = 'toggle git blame split'
        })

        -- Text object
        vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {
          buffer = bufnr
        })
      end
    }
  },

}
