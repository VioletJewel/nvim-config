-- Author: Violet
-- Last Change: 06 September 2023

local au = require'utils'.augroup'VioletAutocmds'

au{
  'BufWinLeave,VimLeave',
  command = 'call mkview#make()',
  desc    = 'save view automagically'
}

au{
  'BufWinEnter',
  command = 'call mkview#load()',
  desc    = 'restore view automagically'
}

au{
  'BufWinEnter,FileType',
  command = 'setl fo+=r fo-=o',
  desc    = 'o/O: do NOT insert comment when using; i_Return: DO insert comment'
}

au{
  'SwapExists',
  command = "call autocmd#HandleSwap(expand('<afile>:p'))",
  desc    = 'auto-handle swapfiles to avoid interruptions'
}

au{
  'BufWritePre',
  command = 'call autocmd#updateLastChange()',
  desc    = 'auto-update "Last Changed" in comment'
}

au{
  'CmdwinEnter',
  command = 'setl nofoldenable foldlevel=99',
  desc    = "don't fold the command window"
}

au{
  'VimEnter,BufNew',
  callback = function(evt)
    if evt.file:match'^/tmp' then
      vim.opt_local.swapfile = false
      vim.opt_local.writebackup = false
      vim.opt_local.backup = false
    end
  end,
  desc = "don't store swap, backup, viminfo files for /tmp files"
}

au{
  'CmdlineChanged',
  pattern = '[/?]',
  command = 'silent! foldopen',
  desc    = 'open folds when searching with incsearch (^g, ^t)'
}

local docdir = vim.fn.stdpath'config'..'/doc'

au{
  'BufWritePost',
  pattern = docdir..'/*.txt',
  callback = function()
    vim.cmd.helptags(docdir)
  end,
  desc = "auto update violet's nvim help docs"
}

au{
  'FileType',
  pattern = 'help',
  command = [[syn match VimHelpModeline /^\s*vim:.*:\%$/ conceal]]
}

-- au BufRead,BufNew *.heex,*.sface set ft=eelixir
vim.filetype.add {
  extension = {
    heex = 'eelixir',
    sface = 'eelixir'
  }
}

au{
  'FileType',
  pattern = '*',
  callback = function()
    if require "vim.treesitter.highlighter".active[vim.api.nvim_get_current_buf()] then
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    end
  end,
  desc = 'auto-set fdm=nvim_treesitter#foldexpr() if ts enabled'
}

