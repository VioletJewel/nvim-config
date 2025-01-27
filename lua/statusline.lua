local au = require 'utils.augroup' 'VioletStatusline'

local function getHl(c)
  local p = nil
  local hl = { link = c }
  while p ~= hl and hl.link do
    p, hl = hl, vim.api.nvim_get_hl(0, { name = hl.link })
  end
  return hl
end

local function stlHl(hl, to) -->
  local f, sc, sn = getHl(hl), getHl 'StatusLine', getHl 'StatusLineNC'

  vim.api.nvim_set_hl(0, 'Stl' .. hl, {
    fg = f.fg,
    bg = sc.reverse and sc.fg or sc.bg,
    reverse = false,
    ctermfg = f.ctermfg,  --- @diagnostic disable-line:undefined-field
    ctermbg = sc.ctermbg, --- @diagnostic disable-line:undefined-field
  })
  vim.api.nvim_set_hl(0, 'Stl' .. hl .. 'NC', {
    fg = f.fg,
    bg = sn.reverse and sn.fg or sn.bg,
    reverse = false,
    ctermfg = f.ctermfg,  --- @diagnostic disable-line:undefined-field
    ctermbg = sn.ctermbg, --- @diagnostic disable-line:undefined-field
  })
  vim.api.nvim_set_hl(0, 'Stl' .. to .. '', { link = 'Stl' .. hl })
  vim.api.nvim_set_hl(0, 'Stl' .. to .. 'NC', { link = 'Stl' .. hl .. 'NC' })
end --<

au { 'ColorScheme', callback = function()
  stlHl('Statement', 'Lnr')
  stlHl('Identifier', 'Ft')
end, }

function StlHl(c, nc)
  return '%#' .. (tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()
    and c or (nc or c .. 'NC')) .. '#'
end

-- TODO: consider updating iconCache on autocmd FileType, but it's pretty fast as is
local icons = nil
local iconCache = {}
local iconOpts = { default = true }
function StlIcon() -->
  local curBuf = vim.api.nvim_get_current_buf()
  local ft = vim.bo.ft
  if iconCache[curBuf] and iconCache[curBuf][ft] then return iconCache[curBuf][ft] end
  if not icons then
    local ok
    ok, icons = pcall(require, 'nvim-web-devicons')
    if not ok then
      StlIcon = function() return vim.o.filetype end
      icons = nil
      return vim.o.filetype
    end
  end
  local icon = icons.get_icon(vim.api.nvim_buf_get_name(0), ft, iconOpts)
  iconCache[curBuf] = { [ft] = icon }
  return icon
end --<

if os.getenv 'TERM' == 'linux' then
  vim.o.statusline = '%=%80(%f%{%v:lua.StlHl("StlLnr")%}:%3l%*%( [%M%R%W]%) [%{&ft}]  %)'
  vim.o.rulerformat = '%80(%=%f%#Statement#:%3l%*%( [%M%R%W]%) [%{&ft}] %)'
else
  vim.o.statusline =
  '%=%80(%f%{%v:lua.StlHl("StlLnr")%}:%3l%*%( [%M%R%W]%) %{%v:lua.StlHl("StlFt")%}%{v:lua.StlIcon()}  %)'
  vim.o.rulerformat = '%80(%=%f%#Statement#:%3l%*%( [%M%R%W]%) %#Identifier#%{v:lua.StlIcon()} %)'
end

-- function SetCmdHeight()
--   vim.o.cmdheight = #vim.api.nvim_tabpage_list_wins(0) > 1 and 0 or 1
-- end
-- au { 'WinResized', callback = SetCmdHeight }
-- SetCmdHeight()

vim.o.laststatus = 1
vim.o.ruler = true
