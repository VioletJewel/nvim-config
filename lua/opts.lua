local function d(o, a, r)
  local opt = vim.opt[o]
  vim.o[o] = opt._info.default
  if a then opt:append(a) end
  if r then opt:remove(r) end
end
local au = require 'utils'.augroup 'ViOpts'

local tty = os.getenv 'TERM' == 'linux'

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.o.backup = true
vim.o.backupext = '.bak'
vim.opt.backupdir:remove '.'
vim.o.undofile = true
vim.o.undolevels = 10000

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 0
vim.o.shiftround = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.textwidth = 80
vim.o.colorcolumn = '' -- '+1'
vim.o.wrap = true

vim.o.conceallevel = 2
vim.o.concealcursor = 'nv'

vim.o.guifont = 'FiraCode Nerd Font:h12'
vim.o.guicursor = 'a:block'
vim.o.mouse = ''

vim.o.termguicolors = true

do -- {{{
  local function getHl(c)
    local p = nil
    local hl = { link = c }
    while p ~= hl and hl.link do
      p, hl = hl, vim.api.nvim_get_hl(0, { name = hl.link })
    end
    return hl
  end
  local function stlHl(hl, to) ---@diagnostic disable: undefined-field
    local f, sc, sn = getHl(hl), getHl 'StatusLine', getHl 'StatusLineNC'
    vim.api.nvim_set_hl(0, 'Stl' .. hl, {
      fg = f.fg,
      bg = sc.reverse and sc.fg or sc.bg,
      reverse = false,
      ctermfg = f.ctermfg,
      ctermbg = sc.ctermbg,
    })
    vim.api.nvim_set_hl(0, 'Stl' .. hl .. 'NC', {
      fg = f.fg,
      bg = sn.reverse and sn.fg or sn.bg,
      reverse = false,
      ctermfg = f.ctermfg,
      ctermbg = sn.ctermbg,
    })
    vim.api.nvim_set_hl(0, 'Stl' .. to .. '', { link = 'Stl' .. hl })
    vim.api.nvim_set_hl(0, 'Stl' .. to .. 'NC', { link = 'Stl' .. hl .. 'NC' })
  end ---@diagnostic enable: undefined-field

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
  function StlIcon()
    local curBuf = vim.api.nvim_get_current_buf()
    local ft = vim.bo.ft
    if iconCache[curBuf] and iconCache[curBuf][ft] then return iconCache[curBuf][ft] end
    if not icons then
      local ok
      ok, icons = pcall(require, 'nvim-web-devicons')
      if not ok then return end
    end
    local icon = icons.get_icon(vim.api.nvim_buf_get_name(0), ft, iconOpts)
    iconCache[curBuf] = { [ft] = icon }
    return icon
  end

  if tty then
    vim.o.statusline = '%=%80(%f%{%v:lua.StlHl("StlLnr")%}:%l%*%( [%M%R%W]%) [%{&ft}]  %)'
    vim.o.rulerformat = '%80(%=%f%#Statement#:%l%*%( [%M%R%W]%) [%{&ft}] %)'
  else
    vim.o.statusline = '%=%80(%f%{%v:lua.StlHl("StlLnr")%}:%l%*%( [%M%R%W]%) %{%v:lua.StlHl("StlFt")%}%{v:lua.StlIcon()}  %)'
    vim.o.rulerformat = '%80(%=%f%#Statement#:%l%*%( [%M%R%W]%) %#Identifier#%{v:lua.StlIcon()} %)'
  end

end -- }}}

function Foldtext()
  local l1 = vim.fn.getline(vim.v.foldstart)
  local l2 = vim.fn.getline(vim.v.foldend)
  if vim.wo.foldmethod == 'marker' then
    local fmr = vim.wo.foldmarker
    local com = fmr:find ','
    local cms = vim.bo.commentstring
    cms = cms:sub(1, cms:find '%s*%%s' - 1)
    local f1 = fmr:sub(1, com - 1):gsub('[][%%.+*]', '%%%1')
    local f2 = fmr:sub(com + 1):gsub('[][%%.+*]', '%%%1')
    l1 = l1:gsub(cms .. '%s*' .. f1, ''):gsub('%s*' .. f1, '')
    l2 = l2:gsub(cms .. '%s*' .. f2, ''):gsub('%s*' .. f2, ''):gsub('^%s+', '')
  end
  return string.format('%s (×%d) %s', l1:gsub('^ ? ?', '|>'), vim.v.foldend - vim.v.foldstart, l2)
end
vim.opt.foldtext = 'v:lua.Foldtext()'


-- function SetCmdHeight()
--   vim.o.cmdheight = #vim.api.nvim_tabpage_list_wins(0) > 1 and 0 or 1
-- end

-- au { 'WinResized', callback = SetCmdHeight }
-- SetCmdHeight()

vim.o.laststatus = 1
vim.o.ruler = true

vim.o.showmode = false
vim.o.showcmd = false

d('shortmess', 'acCAWI')

vim.o.virtualedit = 'insert,block'

vim.o.synmaxcol = 256
vim.o.lazyredraw = true

d('cpoptions', 'y')

d('diffopt', 'foldcolumn:0,indent-heuristic')

vim.o.completeopt = 'menuone,noinsert'

vim.o.foldlevelstart = 2
vim.o.foldmethod = 'marker'

vim.o.breakindent = true
vim.o.showbreak = '->> '

vim.o.listchars = 'trail:·,tab:›·,nbsp:○'
vim.o.fillchars = 'fold: ,diff:~'
if tty then
  vim.opt.fillchars:append 'eob:.'
else
  vim.opt.fillchars:append 'eob:'
end

vim.o.grepprg = vim.fn.executable 'rg' == 1 and 'rg --vimgrep --no-heading' or vim.opt.grepprg._info.default

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true

vim.o.timeout = false
vim.o.ttimeoutlen = 5
