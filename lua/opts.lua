-- Author: Violet
-- Last Change: 30 April 2023

-- helpers {{{1

local default = function(op) return vim.api.nvim_get_option_info(op).default end
local executable = function(cmd) return vim.fn.executable(cmd) ~= 0 end
local nvim_dir = function(t)
  local e = vim.fn.getenv('NVIM_'..t..'_DIR')
  if e == vim.NIL then
    return ''
  end
  return e and tostring(e)
end

-- $XDG_{DATA,CACHE}_DIR {{{1
for _,p in ipairs{'data', 'cache'} do
  local e = tostring(vim.fn.getenv(string.format('XDG_%s_DIR', string.upper(p))))
  local e1 = e..'/nvim'
  vim.fn.setenv('NVIM_'..p:upper()..'_DIR', e and e1 or vim.fn.stdpath(p))
end

-- $NVIM_{BACKUP,SWAP,UNDO}_DIR {{{1
for p,t in pairs({['BACKUP']='DATA', ['SWAP']='CACHE', ['UNDO']='DATA'}) do
  local e = nvim_dir(p)
  if e == '' or not e then
    e = 'NVIM_'..p..'_DIR'
    local dir = vim.fn.stdpath(t:lower())..'/'..p:lower()
    vim.fn.setenv(e, dir)
    vim.fn.mkdir(dir, 'p')
  end
end

-- }}}

vim.o.backup         = true
vim.o.backupdir      = nvim_dir'BACKUP'..'//'
vim.o.backupext      = '.bak'
vim.o.breakindent    = false
vim.o.breakindentopt = 'min:80,sbr'
vim.o.colorcolumn    = '+0'
vim.o.completeopt    = 'menu,menuone'
vim.o.cpoptions      = default'cpo'..'y'
vim.o.diffopt        = default'dip'..',foldcolumn:0,indent-heuristic'
vim.o.directory      = nvim_dir'SWAP'..'//'
vim.o.expandtab      = true
vim.o.fillchars      = 'fold: ,eob:▢,diff:~'
vim.o.foldlevelstart = 1
vim.o.foldmethod     = 'marker'
vim.o.grepprg        = executable'rg' and 'rg --vimgrep --no-heading' or default'grepprg'
vim.o.guicursor      = 'n-v-ve-o-i-r-c-ci-cr-sm-a:blinkon0'
vim.o.hidden         = true
vim.o.ignorecase     = true
vim.o.inccommand     = 'nosplit'
vim.o.joinspaces     = false
vim.o.laststatus     = 0
vim.o.lazyredraw     = true
vim.o.list           = false
vim.o.listchars      = 'trail:·,tab:›·,nbsp:○'
vim.o.mouse          = nil
vim.o.pumheight      = 10
vim.o.ruler          = false
vim.o.shiftround     = true
vim.o.shiftwidth     = 0
vim.o.shortmess      = 'filnmrwxtToOFcWAcS'
vim.o.showbreak      = '↪'
vim.o.showcmd        = false
vim.o.showmode       = false
vim.o.signcolumn     = 'auto:1'
vim.o.smartcase      = true
vim.o.softtabstop    = 2
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.startofline    = false
vim.o.statusline     = '%f%( [%M%R%W]%)%= %y'
vim.o.suffixes       = default'su'..',.aux,.bbl,.jpg,.png,.log,.out,.toc'
vim.o.synmaxcol      = 256
vim.o.tabstop        = 2
vim.o.textwidth      = 80
vim.o.textwidth      = 80
vim.o.timeout        = false
vim.o.ttimeout       = true
vim.o.ttimeoutlen    = 5
vim.o.undodir        = nvim_dir'UNDO'..'//'
vim.o.undofile       = true
vim.o.updatetime     = 800
vim.o.virtualedit    = 'insert,block'
vim.o.wildignorecase = true
vim.o.winminheight   = 0
vim.o.winminwidth    = 0
vim.o.wrap           = false

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

