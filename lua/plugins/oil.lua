return {

  {
    'stevearc/oil.nvim',
    opts = {
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      cleanup_delay_ms = false,
    },
    keys = {
      { '<Leader>dd', "<Cmd>exe'e'empty(expand('%'))?'.':'%:h'<CR>" },
      { '<Leader>dv', "<Cmd>exe'bel vs'empty(expand('%')) ? '.' : '%:h'<CR>" },
      { '<Leader>dV', "<Cmd>exe'abo vs'empty(expand('%')) ? '.' : '%:h'<CR>" },
      { '<Leader>ds', "<Cmd>exe'bel sp'empty(expand('%')) ? '.' : '%:h'<CR>" },
      { '<Leader>dS', "<Cmd>exe'abo sp'empty(expand('%')) ? '.' : '%:h'<CR>" },
    },
    dependencies = {
      -- { 'echasnovski/mini.icons', opts = {} },
      { 'nvim-tree/nvim-web-devicons', opts = {} },
    },
  },

}
