" vulpo: dark, naturalistic, retro colorscheme by Violet
" setup {{{1
hi clear
if exists('syntax_on')
 syntax reset
endif
let colors_name = 'vulpo'
set background=dark
" :help group-name {{{1
hi Comment cterm=NONE ctermfg=242 ctermbg=NONE
hi Ignore cterm=NONE ctermfg=242 ctermbg=NONE
hi Constant cterm=NONE ctermfg=167 ctermbg=NONE
hi String cterm=NONE ctermfg=65 ctermbg=NONE
hi Identifier cterm=NONE ctermfg=180 ctermbg=NONE
hi Statement cterm=NONE ctermfg=173 ctermbg=NONE
hi Tag cterm=underline ctermfg=173 ctermbg=NONE
hi Bold cterm=bold ctermfg=NONE ctermbg=NONE
hi Underlined cterm=underline ctermfg=NONE ctermbg=NONE
hi Error cterm=bold,reverse ctermfg=167 ctermbg=16
hi Todo cterm=bold,reverse ctermfg=65 ctermbg=16
" :help highlight-groups {{{1
hi Normal cterm=NONE ctermfg=187 ctermbg=234
hi StatusLine cterm=NONE ctermfg=251 ctermbg=238
hi StatusLineNC cterm=NONE ctermfg=180 ctermbg=236
hi TabLine cterm=underline ctermfg=180 ctermbg=238
hi TabLineFill cterm=NONE ctermfg=65 ctermbg=233
hi TabLineSel cterm=bold ctermfg=180 ctermbg=242
hi Pmenu cterm=NONE ctermfg=173 ctermbg=238
hi PmenuSel cterm=NONE ctermfg=180 ctermbg=242
hi PmenuSbar cterm=reverse ctermfg=238 ctermbg=NONE
hi PmenuThumb cterm=reverse ctermfg=65 ctermbg=NONE
hi WildMenu cterm=bold,reverse ctermfg=173 ctermbg=16
hi Title cterm=underline ctermfg=66 ctermbg=NONE
hi SpecialKey cterm=NONE ctermfg=66 ctermbg=NONE
hi NonText cterm=NONE ctermfg=66 ctermbg=233
hi EndOfBuffer cterm=NONE ctermfg=66 ctermbg=16
hi Search cterm=bold,reverse ctermfg=173 ctermbg=16
hi IncSearch cterm=bold,reverse ctermfg=180 ctermbg=NONE
hi QuickFixLine cterm=bold ctermfg=NONE ctermbg=236
hi Conceal cterm=NONE ctermfg=101 ctermbg=238
hi Cursor cterm=reverse ctermfg=251 ctermbg=16
hi lCursor cterm=reverse ctermfg=251 ctermbg=16
hi CursorIM cterm=reverse ctermfg=251 ctermbg=16
hi Directory cterm=NONE ctermfg=109 ctermbg=NONE
hi ErrorMsg cterm=bold,reverse ctermfg=167 ctermbg=16
hi WarningMsg cterm=bold,reverse ctermfg=180 ctermbg=16
hi ModeMsg cterm=bold ctermfg=173 ctermbg=NONE
hi SpellBad cterm=bold,reverse ctermfg=167 ctermbg=NONE
hi SpellCap cterm=bold,reverse ctermfg=167 ctermbg=NONE
hi SpellLocal cterm=bold,reverse ctermfg=167 ctermbg=NONE
hi SpellRare cterm=bold,reverse ctermfg=167 ctermbg=NONE
hi DiffAdd cterm=bold,reverse ctermfg=65 ctermbg=NONE
hi DiffDelete cterm=NONE ctermfg=95 ctermbg=95
hi DiffChange cterm=reverse ctermfg=101 ctermbg=NONE
hi DiffText cterm=bold,reverse ctermfg=180 ctermbg=NONE
hi DiffAdded cterm=bold ctermfg=65 ctermbg=236
hi DiffRemoved cterm=bold ctermfg=167 ctermbg=236
hi ColorColumn cterm=NONE ctermfg=NONE ctermbg=235
hi CursorColumn cterm=NONE ctermfg=NONE ctermbg=235
hi CursorLine cterm=NONE ctermfg=NONE ctermbg=235
hi Visual cterm=NONE ctermfg=101 ctermbg=238
hi VisualNOS cterm=NONE ctermfg=101 ctermbg=238
hi VertSplit cterm=NONE ctermfg=65 ctermbg=238
hi LineNr cterm=NONE ctermfg=66 ctermbg=233
hi CursorLineNr cterm=bold ctermfg=109 ctermbg=233
hi LineNrAbove cterm=NONE ctermfg=180 ctermbg=233
hi LineNrBelow cterm=NONE ctermfg=180 ctermbg=233
hi FoldColumn cterm=NONE ctermfg=167 ctermbg=233
hi SignColumn cterm=NONE ctermfg=180 ctermbg=233
hi MatchParen cterm=bold ctermfg=173 ctermbg=238
" conditionals {{{1
if get(g:, 'vulpo_true_italic', 1)
 hi Italic cterm=italic ctermfg=NONE ctermbg=NONE
else
 hi Italic cterm=bold ctermfg=101 ctermbg=NONE
endif
" ft-specific modifications {{{1
if get(g:, 'vulpo_ft_mods', 1)
 hi! link cStorageClass Statement
 hi! link cEnum Statement
 hi! link cTypedef Statement
 hi! link cMacroName Identifier
 hi! link cDataStructureKeyword Identifier
 hi! link vimHiAttrib Constant
 hi! link vimCommentTitle Title
endif
" general links {{{1
hi! link Function Identifier
hi! link PreProc Identifier
hi! link Special Identifier
hi! link Type Identifier
hi! link HtmlBold Bold
hi! link HtmlItalic Italic
hi! link Terminal Normal
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link Folded NonText
hi! link MoreMsg ModeMsg
hi! link Question ModeMsg
