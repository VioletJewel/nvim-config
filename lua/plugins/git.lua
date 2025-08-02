local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
-- local event = require 'pckr.loader.event'

return {

  {
    'tpope/vim-fugitive',
    cond = {
      keys('n', '<Space>gg'),
      cmd 'G',
      cmd 'Git',
      cmd 'Ggrep',
      cmd 'Glgrep',
      -- cmd 'Gclog',
      cmd 'Gcd',
      -- cmd 'Glcd',
      cmd 'Gedit',
      cmd 'Gdiffsplit',
    },
    config_pre = function()
      vim.keymap.set('n', '<Space>gg', function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd.Git { mods = { vertical = true, split = "topleft" } }
        if #vim.api.nvim_tabpage_list_wins(0) == 2 and vim.bo[buf].buftype == '' and #vim.fn.undotree(buf).entries == 0 then
          vim.cmd.wincmd 'o'
        end
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
      end, {
        silent = true,
        desc = 'open :Git|only (if no active windows) or :top vert Git (otherwise)'
      })
    end,
  },

  {
    'junegunn/gv.vim',
    requires = { 'tpope/vim-fugitive' },
  },

  {
    'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
    requires = 'stevearc/dressing.nvim',
  },

  {
    'SuperBo/fugit2.nvim',
    cond = {
      keys('n', '<Space>gf'),
      cmd 'Fugit2', cmd 'Fugit2Diff', cmd 'Fugit2Graph'
    },
    requires = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      'chrisgrieser/nvim-tinygit',
    },
    config_pre = function()
      vim.api.nvim_set_keymap('n', '<Leader>gf', '<Cmd>Fugit2<CR>', { noremap = true })
    end,
    config = function()
      require 'fugit2'.setup {
        width = 100,
      }
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    cond = {
      keys('n', ']c'),
      keys('n', '[c'),
      -- keys('n', '<Bslash>gss'),
      -- keys('n', '<Bslash>gsn'),
      -- keys('n', '<Bslash>gsl'),
      -- keys('n', '<Bslash>gsw'),
      -- keys('n', '<Bslash>gsb'),
      -- keys('n', '<LocalLeader>hS'),
      -- keys('n', '<LocalLeader>hu'),
      -- keys('n', '<LocalLeader>hR'),
      -- keys('n', '<LocalLeader>hp'),
      -- keys('n', '<LocalLeader>hb'),
      -- keys('n', '<LocalLeader>tb'),
      -- keys('n', '<LocalLeader>hd'),
      -- keys('n', '<LocalLeader>hD'),
      -- keys('n', '<LocalLeader>td'),
      -- keys('n', '<LocalLeader>gb'),
      -- keys('n', '<LocalLeader>gB'),
      keys({ 'o', 'x' }, 'ih', function()
        require 'gitsigns'.select_hunk()
      end) -- ':<C-U>Gitsigns select_hunk<CR>'),
    },
    config = function()
      require 'gitsigns'.setup {
        signcolumn = false, -- Toggle w :Gitsigns toggle_signs
        -- numhl      = false, -- Toggle w :Gitsigns toggle_numhl
        -- linehl     = false, -- Toggle w :Gitsigns toggle_linehl
        -- word_diff  = false, -- Toggle w :Gitsigns toggle_word_diff
        on_attach = function(bufnr)
          local gitsigns = require 'gitsigns'
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.api.nvim_feedkeys(']c', 'nt', false)
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

          -- -- Actions
          -- vim.keymap.set('n', '<LocalLeader>hs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('x', '<LocalLeader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'reset gitsigns hunk' })
          -- vim.keymap.set('x', '<LocalLeader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hS', gitsigns.stage_buffer, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hu', gitsigns.undo_stage_hunk, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hR', gitsigns.reset_buffer, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hb', function() gitsigns.blame_line { full = true } end, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>tb', gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hd', gitsigns.diffthis, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>hD', function() gitsigns.diffthis('~') end, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- vim.keymap.set('n', '<LocalLeader>td', gitsigns.toggle_deleted, { buffer = bufnr, desc = 'stage gitsigns hunk' })
          -- -- git blame
          -- vim.keymap.set('n', '<LocalLeader>gb', gitsigns.blame_line, { buffer = bufnr, desc = 'show git blame on current line' })
          -- vim.keymap.set('n', '<LocalLeader>gB', gitsigns.blame, { buffer = bufnr, desc = 'toggle git blame split' })
          -- -- -- Text object
          -- -- vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })

        end
      }
      -- local function toggle(desc, action) return function() print(desc .. ' ' .. (require 'gitsigns'[action]() and 'on' or 'off')) end
      -- end
      -- vim.keymap.set('n', '<LocalLeader>gss', toggle('sign-column signs', 'toggle_signs'), { buffer = true, desc = 'toggle gitsigns sign-column signs' })
      -- vim.keymap.set('n', '<LocalLeader>gsn', toggle('linenr highlight', 'toggle_numhl'), { buffer = true, desc = 'toggle gitsigns linenr highlight' })
      -- vim.keymap.set('n', '<LocalLeader>gsl', toggle('inline highlight', 'toggle_linehl'), { buffer = true, desc = 'toggle gitsigns inline highlight' })
      -- vim.keymap.set('n', '<LocalLeader>gsw', toggle('word diff', 'toggle_word_diff'), { buffer = true, desc = 'toggle gitsigns word diff' })
      -- vim.keymap.set('n', '<LocalLeader>gsb', toggle('auto git blame', 'toggle_current_line_blame'), { buffer = true, desc = 'toggle gitsigns auto git blame' })
    end,
  },
}
