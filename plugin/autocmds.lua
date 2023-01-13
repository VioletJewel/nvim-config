-- Author: Violet
-- Last Change: 13 January 2023

local au = require'utils'.buildaugroup('VioletAutocmds')

au{ 'BufWinLeave,VimLeave', 'call mkview#make()',
    'save view automagically'}
au{'BufWinEnter', 'call mkview#load()',
  'restore view automagically'}

au{'BufWinEnter,FileType', 'setl fo+=r fo-=o',
  'do NOT insert comment when using o/O in normal mode EVER; ' ..
  'DO insert comment when pressing <cr> in insert mode in a commented line'}

au{'SwapExists', "call autocmd#HandleSwap(expand('<afile>:p'))",
  'auto-handle swapfiles to avoid interruptions'}

au{'BufWritePre', 'call autocmd#updateLastChange()',
  'auto-update "Last Changed" in comment'}

au{'CmdwinEnter', 'setl nofoldenable foldlevel=99',
  "don't fold the command window"}

-- don't store swap, backup, viminfo for files in /tmp
au{'VimEnter,BufNew', [[  if expand('<afile>:p') =~ '^/tmp'
                            setl noswapfile nowritebackup nobackup
                          endif ]],
  "don't store swap, backup, viminfo files in /tmp"}

au{'CmdlineChanged', 'silent! foldopen', pattern='[/?]',
  'open folds when searching with incsearch (^g, ^t)'}

-- au{'ColorScheme', 'highlight Normal ctermbg=NONE guibg=NONE', pattern='nokto'}

