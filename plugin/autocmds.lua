local au = require 'utils'.augroup 'VioletAutocmds'

local no_mkview_filetypes = { '', 'gitcommit', 'netrw', 'help' }

local function should_mkview(evt)
  -- tl;dr: :let g:no_mkview_filetypes = ['python', 'lua']
  --        :let b:no_mkview = 1
  local nomkvft = {}
  vim.list_extend(nomkvft, no_mkview_filetypes)
  vim.list_extend(nomkvft, vim.g.no_mkview_filetypes or {})
  vim.list_extend(nomkvft, vim.b[evt.buf].no_mkview_filetypes or {})
  vim.list_extend(nomkvft, vim.w.no_mkview_filetypes or {})
  return vim.bo[evt.buf].buflisted
      and #vim.api.nvim_buf_get_name(evt.buf) > 0
      and not (vim.g.no_mkview or vim.b[evt.buf].no_mkview or vim.w.no_mkview)
      and not vim.list_contains(nomkvft, vim.bo[evt.buf].filetype)
end

au { 'BufWinLeave,VimLeave',
  callback = function(evt)
    if should_mkview(evt) then
      local vop = vim.go.viewoptions
      vim.go.viewoptions = 'cursor,folds'
      vim.cmd.mkview { bang = true, mods = { emsg_silent = true } }
      vim.go.viewoptions = vop
    end
  end,
  desc = 'Auto make view (restore cursor, folds, scroll) for most filetypes'
}

au { 'BufWinEnter',
  callback = function(evt)
    if should_mkview(evt) then
      vim.cmd.loadview { mods = { emsg_silent = true } }
    end
  end,
  desc = 'Auto load view (restore cursor, folds, scroll) for most filetypes'
}

au { 'BufWinEnter,Filetype',
  callback = function()
    vim.opt_local.formatoptions:append 'r'
    vim.opt_local.formatoptions:remove 'o'
  end,
  desc = 'normal o/O do NOT insert comment; insert <CR> DOES insert comment',
}

au { 'CmdwinEnter',
  callback = function()
    vim.wo.foldenable = false
    vim.wo.foldlevel = 99
  end,
  desc = 'Never fold the command window',
}

au { 'VimEnter,BufNew,BufRead',
  pattern = '/tmp*',
  callback = function(evt)
    if evt.file:match '^/tmp' then
      vim.bo.swapfile = false
    end
  end,
  desc = 'Do NOT store swapfiles for /tmp/*'
  -- 'backupskip' also ignores backups in /tmp
}

au { 'FileType',
  pattern = '*',
  callback = function()
    if require 'vim.treesitter.highlighter'.active[vim.api.nvim_get_current_buf()] then
      -- vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    end
  end,
  desc = 'auto-set fdm=nvim_treesitter#foldexpr() if ts enabled'
}

au { 'FileType',
  pattern = 'help',
  command = [[syn match VimHelpModeline /^\s*vim:.*:\%$/ conceal]]
}

local function hlLink(group)
  local from, to = group:match '^(%S+)%s+(%S+)$'
  vim.api.nvim_set_hl(0, from, { link = to })
end

au { 'ColorScheme',
  pattern = 'dracula',
  callback = function()
    hlLink 'SpecialKey DraculaPink'
    hlLink 'LazyNormal Normal'
    hlLink 'FloatBorder NonText'
    hlLink '@keyword.luadoc None'
    hlLink '@lsp.type.keyword DraculaPurpleBold'
    hlLink '@lsp.type.event.lua DraculaPurple'
  end,
  desc = 'modify dracula to be cuter :3 and better :D',
}
