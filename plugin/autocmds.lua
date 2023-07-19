-- Author: Violet
-- Last Change: 19 July 2023

local au = require'utils'.augroup('VioletAutocmds')

au( 'BufWinLeave,VimLeave', {
  desc    = 'save view automagically',
  command = 'call mkview#make()',
})

au( 'BufWinEnter', {
  desc    = 'restore view automagically',
  command = 'call mkview#load()',
})

au( 'BufWinEnter,FileType', {
  desc    = 'o/O: do NOT insert comment when using; i_Return: DO insert comment',
  command = 'setl fo+=r fo-=o',
})

au( 'SwapExists', {
  desc    = 'auto-handle swapfiles to avoid interruptions',
  command = "call autocmd#HandleSwap(expand('<afile>:p'))",
})

au( 'BufWritePre', {
  command = 'call autocmd#updateLastChange()',
  desc    = 'auto-update "Last Changed" in comment'
})

au( 'CmdwinEnter', {
  desc    = "don't fold the command window",
  command = 'setl nofoldenable foldlevel= 99',
})

au( 'VimEnter,BufNew', {
  desc     = "don't store swap, backup, viminfo files for /tmp files",
  callback = function(evt)
    if evt.file:match'^/tmp' then
      vim.opt_local.swapfile = false
      vim.opt_local.writebackup = false
      vim.opt_local.backup = false
    end
  end,
})

au( 'CmdlineChanged', {
  desc    = 'open folds when searching with incsearch (^g, ^t)',
  command = 'silent! foldopen',
  pattern = '[/?]',
})

-- au BufRead,BufNew *.heex,*.sface set ft=eelixir
vim.filetype.add {
  extension = {
    heex = 'eelixir',
    sface = 'eelixir'
  }
}

