return {

  {
    'tpope/vim-abolish',
    cond = {
      Keys('n', 'cr'),
      Cmd 'Abolish',
      Cmd 'Subvert',
      Cmd 'S',
    },
  },

}
