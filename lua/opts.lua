-- leader setup {{{1

vim.g.mapleader = ' '        -- <Leader>      = <Space>
vim.g.maplocalleader = '\\'  -- <LocalLeader> = <Bslash>

-- backup, undo {{{1

vim.o.backup = true           -- backup file before :write
vim.o.backupext = '.bak'      -- backup extension = .bak
vim.opt.backupdir:remove '.'  -- do not store backups in CWD
vim.o.undofile = true         -- persistent undo file!
vim.o.undolevels = 5000       -- increase # of undos to 5000

-- tabs, indentation {{{1

vim.o.expandtab = true   -- use soft tabs
vim.o.tabstop = 2        -- hard tabs = 2 visual spaces
vim.o.softtabstop = 2    -- soft tabs = 2 actual spaces
vim.o.shiftwidth = 0     -- <<, >> indent 'tabstop' spaces
vim.o.shiftround = true  -- :>, i_^t rounded to 'shiftwidth' multiple

-- split direction {{{1

vim.o.splitbelow = true  -- :sp splits below
vim.o.splitright = true  -- :vsp splits right

-- text width {{{1

vim.o.textwidth = 80      -- text width = 80
-- vim.o.colorcolumn = '+1'  -- colored line at 'textwidth' + 1
vim.o.colorcolumn = ''    -- colored line at 'textwidth' + 1
vim.o.wrap = true         -- hard wrap text after 'textwidth'

-- concealed text {{{1

vim.o.conceallevel = 2
vim.o.concealcursor = 'nv'

-- gui stuff {{{1

if vim.fn.has 'gui_running' then
  vim.o.guifont = 'FiraCode Nerd Font:h12'  -- use FiraCode Nerd in gui nvims
end
vim.o.guicursor = 'a:block'  -- make cursor a block in all modes
vim.o.mouse = ''             -- disable mouse in all modes

vim.o.termguicolors = true  -- use 24-bit color for :colorscheme

-- cmdline area mode, cmd statuses {{{1

vim.o.showmode = false  -- do not show mode in cmdline
vim.o.showcmd = false   -- do now show count/etc during op pending mode, etc

-- shortmess {{{1
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

-- reduce cpu {{{1

vim.o.synmaxcol = 256    -- reduce max syntax rendering per line to 256
vim.o.lazyredraw = true  -- don't redraw during macros, registers, etc

-- cpoptions {{{1
--  A: :w <file> set "# to <cfile>
--  B: \<Esc> = <Bslash><Esc> in rhs of :map
--  c: don't search part of a preexisting match
--  e: add <CR> to :@r
--  E: y/d/c/g~/gu/gU on empty region = error
--  F: :w <file> = <cfile> -> <file> if no fname
--  s: set buf opts when buffer entered (not created)
--  y: yank can be repeated (".")
vim.o.cpoptions = 'ABceEFsy'

-- diffopt {{{1

--  internal = internal diff lib
--  filler = keep text sync'd w filler lines
--  closeoff = :diffoff in last diff window if others closed
--  foldcolumn:0 = disable foldcolumn
--  indent-heuristic = remove noise by collapsing lines w same indent
--  linematch:60 = enable 2nd stage diff (30 lines for 2-way diff)
vim.o.diffopt = 'internal,filler,closeoff,foldcolumn:0,linematch:60,indent-heuristic'

-- ins-completion {{{1

--  menuone = show menu (even for one result)
--  noselect = do not select first match at first (so you can refine match)
vim.o.completeopt = 'menuone,noselect'

-- folding {{{1

vim.o.foldlevelstart = 2     -- always open first 2 fold levels for new bufs
vim.o.foldmethod = 'syntax'  -- use syntax for folding

-- break indent {{{1

vim.o.breakindent = true
if os.getenv 'TERM' == 'st-256color' or vim.fn.has('gui_running') then
vim.o.showbreak = '->> ' -- looks nice with FiraCode Nerd ligatures
end

-- visuals {{{1

--  show trailing ws, hard tabs, non-breaking ws
--  set fold fillchar to emptiness and diff fillchar to squiggles
vim.o.listchars = 'trail:·,tab:›·,nbsp:○'
vim.o.fillchars = 'fold: ,diff:~,eob:.'
-- if os.getenv 'TERM' == 'linux' then
--   vim.opt.fillchars:append 'eob:.'  -- dots end of buffer for tty
-- else
--   vim.opt.fillchars:append 'eob:'  -- cute end of buffer >^_^<
-- end

-- grep {{{1

if vim.fn.executable 'rg' then
  vim.o.grepprg = 'rg --vimgrep --no-heading'  -- use rg (if avail); not grep
end

-- case {{{1

vim.o.ignorecase = true      -- ignore case for search and cmd-cmpl
vim.o.smartcase = true       -- don't ignore case if capital letter used
vim.o.wildignorecase = true  -- ignore case for file tab completion
vim.o.tagcase = 'followscs'  -- tag case follows ignorecase and smartcase

-- file completion {{{1

vim.o.wildignore = '*.o,*.obj,*.jpg,*.png,*.gif'  -- don't complete these files

-- timeout {{{1

vim.o.timeout = false  -- wait forever for mappings; do not timeout
vim.o.ttimeoutlen = 5  -- wait 5ms for next byte in multibyte key code sequence

