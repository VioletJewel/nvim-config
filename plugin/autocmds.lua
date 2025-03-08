local au = require 'utils.augroup' 'VioletAutocmds'

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

au { 'BufWinLeave,VimLeave,WinLeave,BufLeave,BufUnload,CmdlineEnter',
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
      local fdm = vim.wo.foldmarker
      local fde = vim.wo.foldexpr
      -- local fdl = vim.wo.foldlevel
      local fmr = vim.wo.foldmarker
      vim.cmd.loadview { mods = { emsg_silent = true } }
      -- vim.b[evt.buf].no_mkview = true
      vim.opt_local.foldmarker = fdm
      vim.opt_local.foldexpr   = fde
      -- vim.opt_local.foldlevel  = fdl
      vim.opt_local.foldmarker = fmr
    end
  end,
  desc = 'Auto load view (restore cursor, folds, scroll) for most filetypes'
}

-- local function should_mkview(evt) -->
--   -- tl;dr: :let g:no_mkview_filetypes = ['python', 'lua']
--   --        :let b:no_mkview = 1
--   local nomkvft = {}
--   vim.list_extend(nomkvft, no_mkview_filetypes)
--   vim.list_extend(nomkvft, vim.g.no_mkview_filetypes or {})
--   vim.list_extend(nomkvft, vim.b[evt.buf].no_mkview_filetypes or {})
--   vim.list_extend(nomkvft, vim.w.no_mkview_filetypes or {})
--   return vim.bo[evt.buf].buflisted
--       and #vim.api.nvim_buf_get_name(evt.buf) > 0
--       and not (vim.g.no_mkview or vim.b[evt.buf].no_mkview or vim.w.no_mkview)
--       and not vim.list_contains(nomkvft, vim.bo[evt.buf].filetype)
-- end                                                                   --<

-- au { 'BufWinLeave,VimLeave,WinLeave,BufLeave,BufUnload,CmdlineEnter', --> Auto save view
--   callback = function(evt)
--     if should_mkview(evt) then
--       vim.b[evt.buf]._auto_view = vim.fn.winsaveview()
--     end
--   end,
--   desc = 'Auto make view (restore cursor, folds, scroll) for most filetypes'
-- }                            --<

-- au { 'BufWinEnter', --> Auto load view
--   callback = function(evt)
--     if should_mkview(evt) then
--       local av = vim.b[evt.buf]._auto_view
--       if av then
--         vim.fn.winrestview {
--           lnum = av.lnum,
--           col = av.col,
--           curswant = av.curswant,
--           topline = av.topline,
--           leftcol = av.leftcol,
--         }
--       else
--         vim.api.nvim_input 'g`"'
--       end
--     end
--   end,
--   desc = 'Auto load view (restore cursor, folds, scroll) for most filetypes'
-- }                            --<

au { 'BufWinEnter,Filetype', --> fix o/O
  callback = function()      -->
    vim.opt_local.formatoptions:append 'r'
    vim.opt_local.formatoptions:remove 'o'
  end,              --<
  desc = 'normal o/O do NOT insert comment; insert <CR> DOES insert comment',
}                   --<

au { 'CmdwinEnter', --> don't fold cmdwin
  callback = function()
    vim.wo.foldenable = false
    vim.wo.foldlevel = 99
  end,
  desc = 'Never fold the command window',
}                               --<

au { 'VimEnter,BufNew,BufRead', --> no swap for /tmp
  pattern = '/tmp*',
  callback = function(evt)
    if evt.file:match '^/tmp' then
      vim.bo.swapfile = false
    end
  end,
  desc = 'Do NOT store swapfiles for /tmp/*'
  -- 'backupskip' also ignores backups in /tmp
} --<

-- au { 'FileType', --> set foldexpr to treesitter
--   pattern = '*',
--   callback = function()
--     if require 'vim.treesitter.highlighter'.active[vim.api.nvim_get_current_buf()] then
--       -- vim.opt_local.foldmethod = 'expr'
--       vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
--     end
--   end,
--   desc = 'auto-set fdm=nvim_treesitter#foldexpr() if ts enabled'
-- } --<

--au { 'BufNew',
--  ---@diagnostic disable-next-line: param-type-mismatch
--  pattern = vim.fs.joinpath(vim.fn.fnameescape(vim.fn.stdpath 'config'), 'lua', 'plugins', '*.lua'),
--  callback = function(evt)
--    -- if vim.b[evt.buf].pckrPluginSkeletonLoad then
--    --   print 'pckr skeleton load again :('
--    --   return
--    -- end
--    -- print 'pckr skeleton load'
--    -- vim.b[evt.buf].pckrPluginSkeletonLoad = true
--    vim.bo[evt.buf].filetype = 'lua'
--    vim.api.nvim_buf_set_lines(evt.buf, 0, 1, true, {
--      "-- local cmd = require 'pckr.loader.cmd'",
--      "-- local keys = require 'pckr.loader.keys'",
--      "-- local event = require 'pckr.loader.event'",
--      "",
--      "return {",
--      "}",
--    })
--  end,
--  desc = 'Populate new plugin with a skeleton'
--}


au { 'BufNewFile',
  ---@diagnostic disable-next-line: param-type-mismatch
  pattern = vim.fs.joinpath(vim.fn.fnameescape(vim.fn.stdpath 'config'), 'lua', 'plugins', '*.lua'),
  callback = function(evt)
    if vim.b[evt.buf].pckrPluginGuard then
      return
    end
    vim.b[evt.buf].pckrPluginGuard = true
    vim.api.nvim_buf_set_lines(evt.buf, 0, 1, true, {
      "-- local cmd = require 'pckr.loader.cmd'",
      "-- local keys = require 'pckr.loader.keys'",
      "-- local event = require 'pckr.loader.event'",
      "",
      "return {",
      "}",
    })
  end,
  desc = 'Populate new plugin with a skeleton'
}

-- au { 'FileType',
--   pattern = 'help',
--   command = [[syn match VimHelpModeline /^\s*vim:.*:\%$/ conceal]]
-- }

local function hlLink(group)
  local from, to = group:match '^(%S+)%s+(%S+)$'
  vim.api.nvim_set_hl(0, from, { link = to })
end

local function gethl(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  while hl.link do
    hl = vim.api.nvim_get_hl(0, { name = hl.link })
  end
  return hl
end

local eobsav

local function ColorSchemePost() -->
  -- if synIDattr(hlID('@variable'), 'fg') == 'NvimLightGrey2'
  if vim.deep_equal(gethl '@variable', { fg = 14738154 }) then
    -- hi clear @variable
    vim.api.nvim_set_hl(0, '@variable', {})
  end

  -- if synIDattr(hlID('Operator'), 'fg') == 'NvimLightGrey2'
  if vim.deep_equal(gethl 'Operator', { fg = 14738154 }) then
    -- hi! link Operator Special
    vim.api.nvim_set_hl(0, 'Operator', { link = 'Special' })
  end

  -- if synIDattr(hlID('Delimiter'), 'fg') == 'NvimLightGrey2'
  if vim.deep_equal(gethl 'Delimiter', { fg = 14738154 }) then
    -- hi! link Delimiter Special
    vim.api.nvim_set_hl(0, 'Delimiter', { link = 'Special' })
  end

  -- if { h -> synIDattr(h, 'fg') == 'NvimDarkGrey1' && synIDattr(h, 'bg') == 'NvimLightYellow' }(hlID('CurSearch'))
  if vim.deep_equal(gethl 'CurSearch', { bg = 16572564, ctermbg = 11, fg = 460813, ctermfg = 0 }) then
    -- hi! link CurSearch IncSearch
    vim.api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })
  end

  -- if synIDattr(hlID('NormalFloat'), 'bg') == 'NvimDarkGrey1'
  if vim.deep_equal(gethl 'NormalFloat', { bg = 1842204 }) then
    -- hi! link NormalFloat Normal
    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
  end

  -- if { h -> synIDattr(h, 'fg') == 'NvimLightGrey4' &&  synIDattr(h, 'bg') == 'NvimDarkGrey1' && synIDattr(h, 'bold') == 1 }(hlID('WinBar'))
  if vim.deep_equal(gethl 'WinBar', { fg = 10198692, bg = 460813, bold = true, cterm = { bold = true } }) then
    -- hi! link WinBar StatusLine
    vim.api.nvim_set_hl(0, 'WinBar', { link = 'StatusLine' })
  end

  -- if { h -> synIDattr(h, 'fg') == 'NvimLightGrey4' &&  synIDattr(h, 'bg') == 'NvimDarkGrey1' && synIDattr(h, 'bold', 'cterm') == 1 }(hlID('WinBarNC'))
  if vim.deep_equal(gethl 'WinBarNC', { bg = 460813, fg = 10198692, cterm = { bold = true } }) then
    -- hi! link WinBarNC StatusLineNC
    vim.api.nvim_set_hl(0, 'WinBarNC', { link = 'StatusLineNC' })
  end

  if eobsav == nil then
    eobsav = vim.opt.fillchars:get().eob
  end
  if gethl 'EndOfBuffer'.fg == gethl 'Normal'.bg then
    vim.opt.fillchars:append 'eob: '
  else
    vim.opt.fillchars:append('eob:' .. eobsav)
  end
end --<

--- @type table<string, fun()|table>
local colorschemeFixes = { -->

  dracula = function()
    hlLink 'SpecialKey DraculaPink'
    hlLink 'LazyNormal Normal'
    hlLink 'FloatBorder NonText'
    hlLink '@keyword.luadoc None'
    hlLink '@lsp.type.keyword DraculaPurpleBold'
    hlLink '@lsp.type.event.lua DraculaPurple'
  end,

  tokyonight = function()
    -- vim.api.nvim_set_hl(0, 'NonText', { fg = '#4e505e', ctermfg = 239, })
    hlLink 'EndOfBuffer NonText'
  end,

  nokto = function()
    hlLink 'EndOfBuffer Comment'
  end,

} --<

local function nullop() end

for theme, opts in pairs(colorschemeFixes) do -->
  local desc = 'modify ' .. theme .. ' to be cuter :3 and better :)'
  if type(opts) == 'function' then
    opts = { callback = opts }
  elseif not opts.callback then
    opts.callback = nullop
  end
  au {
    'ColorScheme',
    pattern = theme,
    callback = function()
      opts.callback()
      ColorSchemePost()
    end,
    desc = opts.desc or desc,
  }
end                 --<

au { 'ColorScheme', -->
  callback = function(opts)
    if not vim.list_contains(vim.tbl_keys(colorschemeFixes), opts.match) then
      ColorSchemePost()
    end
  end,
  desc = 'fix older colorschemes'
} --<
