-->1 backup, undo

vim.o.backup = true           -- backup file before :write
vim.o.backupext = '.bak'      -- backup extension = .bak
vim.opt.backupdir:remove '.'  -- do not store backups in CWD
vim.o.undofile = true         -- persistent undo file!
vim.o.undolevels = 5000       -- increase # of undos to 5000

-->1 tabs, indentation

vim.o.expandtab = true   -- use soft tabs
vim.o.tabstop = 2        -- hard tabs = 2 visual spaces
vim.o.softtabstop = 2    -- soft tabs = 2 actual spaces
vim.o.shiftwidth = 0     -- <<, >> indent 'tabstop' spaces
vim.o.shiftround = true  -- :>, i_^t rounded to 'shiftwidth' multiple

-->1 split direction

vim.o.splitbelow = true  -- :sp splits below
vim.o.splitright = true  -- :vsp splits right

-->1 text width

vim.o.textwidth = 80      -- text width = 80
-- vim.o.colorcolumn = '+1'  -- colored line at 'textwidth' + 1
vim.o.colorcolumn = ''    -- colored line at 'textwidth' + 1
vim.o.wrap = true         -- hard wrap text after 'textwidth'

-->1 concealed text

vim.o.conceallevel = 2
vim.o.concealcursor = 'nv'

-->1 gui stuff

if vim.fn.has 'gui_running' then
  vim.o.guifont = 'FiraCode Nerd Font:h12'  -- use FiraCode Nerd in gui nvims
end
vim.o.guicursor = 'a:block'  -- make cursor a block in all modes
vim.o.mouse = ''             -- disable mouse in all modes

vim.o.termguicolors = true  -- use 24-bit color for :colorscheme

-->1 cmdline area mode, cmd statuses

vim.o.showmode = false  -- do not show mode in cmdline
vim.o.showcmd = false   -- do now show count/etc during op pending mode, etc

-->1 shortmess
--  a: l + m + r + w                  |  o: overwrite read w write msgs
--   l: "99L" not "99 lines           |  O: overwrite any msg w read msg
--   m: "[+]" not "[Modified]"        |  c: no ins-cmpl msgs
--   r: "[RO]" not "[readonly]"       |  C: no "scanning tags" for ins-cmpl
--   w: "[w]" not "written"           |  F: no :file on :edit
--      "[a]" not "appended"          |  A: no ATTENTION for existing swap
--  t: truncate long msgs at start    |  W: no [w] on :write
--  T: truncate other msgs in middle  |  I: no :intro on VimEnter
vim.opt.shortmess:append 'atToOcCFAWI'

vim.o.virtualedit = 'insert,block'  -- cursor can be anywhere in insert/block

-->1 reduce cpu

vim.o.synmaxcol = 256    -- reduce max syntax rendering per line to 256
vim.o.lazyredraw = true  -- don't redraw during macros, registers, etc

-->1 cpoptions
--  A: :w <file> set "# to <cfile>
--  B: \<Esc> = <Bslash><Esc> in rhs of :map
--  c: don't search part of a preexisting match
--  e: add <CR> to :@r
--  E: y/d/c/g~/gu/gU on empty region = error
--  F: :w <file> = <cfile> -> <file> if no fname
--  s: set buf opts when buffer entered (not created)
--  y: yank can be repeated (".")
vim.o.cpoptions = 'ABceEFsy'

-->1 diffopt

--  internal = internal diff lib
--  filler = keep text sync'd w filler lines
--  closeoff = :diffoff in last diff window if others closed
--  foldcolumn:0 = disable foldcolumn
--  indent-heuristic = remove noise by collapsing lines w same indent
--  linematch:60 = enable 2nd stage diff (30 lines for 2-way diff)
vim.o.diffopt = 'internal,filler,closeoff,foldcolumn:0,linematch:60,indent-heuristic'

-->1 ins-completion

--  menuone = show menu (even for one result)
--  noselect = do not select first match at first (so you can refine match)
vim.o.completeopt = 'menuone'

-->1 folding

vim.o.foldlevelstart = 2     -- always open first 2 fold levels for new bufs
vim.o.foldmethod = 'syntax'  -- use syntax for folding

-- -- ufo
-- vim.o.foldenable = true
-- vim.o.foldcolumn = '0'
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = 99


-->1 break indent

vim.o.breakindent = true
if os.getenv 'TERM' == 'st-256color' or vim.fn.has('gui_running') then
vim.o.showbreak = '~~>' -- looks nice with FiraCode Nerd ligatures
end

-->1 visuals

--  show trailing ws, hard tabs, non-breaking ws
--  set fold fillchar to emptiness and diff fillchar to squiggles
vim.o.listchars = 'trail:·,tab:›·,nbsp:○'
vim.o.fillchars = 'fold: ,diff:~' -- ,eob:.'
if os.getenv 'TERM' == 'linux' then
  vim.opt.fillchars:append 'eob:.'  -- dots end of buffer for tty
else
  if os.getenv 'DVTM' or os.getenv 'ASCIINEMA_REC' == '1' then
    vim.opt.fillchars:append 'eob:♥'  -- cute end of buffer >^_^<
  else
    vim.opt.fillchars:append 'eob:'  -- cute end of buffer >^_^<
  end
end

-->1 grep

if vim.fn.executable 'rg' then
  vim.o.grepprg = 'rg --vimgrep --no-heading'  -- use rg (if avail); not grep
end

-->1 case

vim.o.ignorecase = true      -- ignore case for search and cmd-cmpl
vim.o.smartcase = true       -- don't ignore case if capital letter used
vim.o.wildignorecase = true  -- ignore case for file tab completion
vim.o.tagcase = 'followscs'  -- tag case follows ignorecase and smartcase

-->1 file completion

vim.o.wildignore = '*.o,*.obj,*.jpg,*.png,*.gif'  -- don't complete these files

-->1 timeout

vim.o.timeout = false  -- wait forever for mappings; do not timeout
vim.o.ttimeoutlen = 5  -- wait 5ms for next byte in multibyte key code sequence

