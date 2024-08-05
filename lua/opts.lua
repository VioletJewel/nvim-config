local function d(o, a, r)
  local opt = vim.opt[o]
  vim.o[o] = opt._info.default
  if a then opt:append(a) end
  if r then opt:remove(r) end
end
local au = require 'utils'.augroup'ViOpts'

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
vim.o.colorcolumn = '+0'
vim.o.wrap = true

vim.o.conceallevel = 2
vim.o.concealcursor = 'nv'

vim.o.guicursor = ''
vim.o.mouse = ''

vim.o.laststatus = 2
vim.o.cmdheight = 1

vim.o.termguicolors = true

-- statusline {{{

local function getHl(c)
  local p = nil
  local hl = { link = c }
  while p ~= hl and hl.link do
    p, hl = hl, vim.api.nvim_get_hl(0, { name = hl.link })
  end
  return hl
end
local function stlHl(hl) ---@diagnostic disable: undefined-field
  local f, sc, sn = getHl(hl), getHl 'StatusLine', getHl 'StatusLineNC'
  vim.api.nvim_set_hl(0, 'Stl' .. hl, {
    fg = f.fg,
    bg = sc.bg,
    ctermfg = f.ctermfg,
    ctermbg = sc.ctermbg,
  })
  vim.api.nvim_set_hl(0, 'Stl' .. hl .. 'NC', {
    fg = f.fg,
    bg = sn.bg,
    ctermfg = f.ctermfg,
    ctermbg = sn.ctermbg,
  })
  vim.api.nvim_set_hl(0, 'StlLnr', { link = 'Stl' .. hl })
  vim.api.nvim_set_hl(0, 'StlLnrNC', { link = 'Stl' .. hl .. 'NC' })
end ---@diagnostic enable: undefined-field

au { 'ColorScheme', callback = function() stlHl 'Statement' end, }

function StlHl(c, nc)
  return '%#' .. (tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()
    and c or (nc or c .. 'NC')) .. '#'
end

vim.o.statusline = '%f%{%v:lua.StlHl("StlLnr")%}:%l%*%( [%M%R%W]%)%= %y'

-- }}}

vim.o.showmode = false
vim.o.showcmd = false
vim.o.ruler = false

d('shortmess', 'acCAW')

vim.o.virtualedit = 'insert,block'

vim.o.synmaxcol = 256
vim.o.lazyredraw = true

d('cpoptions', 'y')

d('diffopt', 'foldcolumn:0,indent-heuristic')

vim.o.completeopt = 'menu,menuone'

vim.o.foldlevelstart = 2
vim.o.foldmethod = 'marker'

vim.o.breakindent = true
vim.o.showbreak = '↪'

vim.o.listchars = 'trail:·,tab:›·,nbsp:○'
vim.o.fillchars = 'fold: ,eob:▢,diff:~'

vim.o.grepprg = vim.fn.executable 'rg' == 1 and 'rg --vimgrep --no-heading' or vim.opt.grepprg._info.default

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true

vim.o.timeout = false
vim.o.ttimeoutlen = 5
