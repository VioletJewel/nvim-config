-- local hlNav = true

return {
  'stevearc/oil.nvim',
  lazy = false,
  -- event = 'VeryLazy',
  name = 'oil',
  dependencies = {
    -- { 'echasnovski/mini.icons', opts = {} },
    { 'nvim-tree/nvim-web-devicons' },
  },
  opts = {
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
    },
  },
  keys = {
    { '<Leader>dd', "<Cmd>exe'e'empty(expand('%'))?'.':'%:h'<CR>" },
    { '<Leader>dv', "<Cmd>exe'bel vs'empty(expand('%')) ? '.' : '%:h'<CR>" },
    { '<Leader>dV', "<Cmd>exe'abo vs'empty(expand('%')) ? '.' : '%:h'<CR>" },
    { '<Leader>ds', "<Cmd>exe'bel sp'empty(expand('%')) ? '.' : '%:h'<CR>" },
    { '<Leader>dS', "<Cmd>exe'abo sp'empty(expand('%')) ? '.' : '%:h'<CR>" },
  },
  cmd = { 'Oil' },
}
