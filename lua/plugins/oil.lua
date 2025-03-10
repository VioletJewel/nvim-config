-- local cmd = require 'pckr.loader.cmd'
-- local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

return {
  {
    'stevearc/oil.nvim',
    requires = {
      -- { 'echasnovski/mini.icons', opts = {} },
      { 'nvim-tree/nvim-web-devicons' },
    },
    cond = event 'UIEnter',
    config = function()
      require 'oil'.setup {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        -- cleanup_delay_ms = false,
        keymaps = {
          Y = { 'actions.yank_entry', opts = { modify = ':p' } },
          l = {
            function()
              if vim.w.hlNav == false then
                return 'l'
              end
              require 'oil.actions'.select()
              return ''
            end,
            expr = true,
          },
          h = {
            function()
              if vim.w.hlNav == false then
                return 'h'
              end
              require 'oil.actions'.parent()
              return ''
            end,
            expr = true,
          }
        }
      }
      vim.api.nvim_set_keymap('n', '<Leader>dd', "<Cmd>exe'e'empty(expand('%'))?'.':'%:h'<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>dv', "<Cmd>exe'bel vs'empty(expand('%')) ? '.' : '%:h'<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>dV', "<Cmd>exe'abo vs'empty(expand('%')) ? '.' : '%:h'<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>ds', "<Cmd>exe'bel sp'empty(expand('%')) ? '.' : '%:h'<CR>", { noremap = true })
      vim.api.nvim_set_keymap('n', '<Leader>dS', "<Cmd>exe'abo sp'empty(expand('%')) ? '.' : '%:h'<CR>", { noremap = true })
    end,
  },
}
