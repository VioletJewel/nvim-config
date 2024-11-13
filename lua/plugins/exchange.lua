return {

  {
    'tommcdo/vim-exchange',
    cmd = 'ExchangeClear',
    keys = {
      'cx', { 'X', mode = 'x' },
      '<Plug>(Exchange)', '<Plug>(ExchangeClear)', '<Plug>(ExchangeLine)',
    },
  }

}
