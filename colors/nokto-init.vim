" nokto: dark black, spacey colorscheme by Violet
hi clear
if exists('syntax_on')
  syn reset
endif
let colors_name = 'nokto'
if &background isnot 'dark'
  set background=dark
endif
if has('gui_running') || has('termguicolors') && &termguicolors
  let g:terminal_ansi_colors = ['#303030', '#d7005f', '#afd7af', '#af8787', '#87afd7', '#af87af', '#87afaf', '#d0d0d0', '#808080', '#d787af', '#87af5f', '#d7af87', '#5f8787', '#af87d7', '#5faf87', '#e4e4e4']
endif
hi! link Function Identifier
hi! link PreProc Identifier
hi! link Special Identifier
hi! link Type Identifier
hi! link HtmlBold Bold
hi! link HtmlItalic Italic
hi! link HtmlUnderline Underlined
hi! link Terminal Normal
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link TabLineSel StatusLine
hi! link TablineFill StatusLineNC
hi! link TabLine StatusLineNC
hi! link MoreMsg ModeMsg
hi! link Question ModeMsg
hi! link SpellCap SpellBad
hi! link SpellLocal SpellBad
hi! link SpellRare SpellBad
hi! link TSConstant Constant
hi! link TSConstBuiltin Constant
hi! link TSNumber Number
hi! link TSFloat Float
hi! link TSBoolean Boolean
hi! link TSCharacter Character
hi! link TSString String
hi! link TSStringRegex String
hi! link TSStringEscape String
hi! link TSProperty TSField
hi! link TSParameterReference TSParameter
hi! link TSFunction Function
hi! link TSFuncBuiltin TSFunction
hi! link TSFuncMacro TSFunction
hi! link TSMethod TSFunction
hi! link TSConstructor TSFunction
hi! link TSKeyword Keyword
hi! link TSConditional Conditional
hi! link TSRepeat Repeat
hi! link TSLabel Label
hi! link TSOperator Operator
hi! link TSException Exception
hi! link TSNamespace PreProc
hi! link TSAnnotation TSNamespace
hi! link TSInclude TSNamespace
hi! link TSType Type
hi! link TSTypeBuiltin Type
hi! link TSPunctDelimiter Delimiter
hi! link TSPunctSpecial Delimiter
hi! link TSComment Comment
hi! link TSTag Tag
hi! link TSTagDelimiter Special
hi! link TSLiteral TSString
hi! link TSURI TSSymbol
if get(g:, 'nokto_ft_mods', 1)
  hi! link cStorageClass Statement
  hi! link cEnum Statement
  hi! link cTypedef Statement
  hi! link cMacroName Identifier
  hi! link cDataStructureKeyword Identifier
  hi! link vimHiAttrib Constant
  hi! link markdownCodeBlock markdownCode
endif
if (!empty(&t_Co) && &t_Co > 1 ? &t_Co : 2) < 256
  hi Normal cterm=NONE ctermfg=7 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=#000000
  hi Constant cterm=NONE ctermfg=9 ctermbg=NONE gui=NONE guifg=#d787af guibg=NONE
  hi String cterm=NONE ctermfg=2 ctermbg=NONE gui=NONE guifg=#afd7af guibg=NONE
  hi Identifier cterm=NONE ctermfg=4 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
  hi Statement cterm=NONE ctermfg=5 ctermbg=NONE gui=NONE guifg=#af87af guibg=NONE
  hi Comment cterm=italic ctermfg=8 ctermbg=NONE gui=italic guifg=#808080 guibg=NONE
  hi Ignore cterm=NONE ctermfg=8 ctermbg=NONE gui=NONE guifg=#808080 guibg=NONE
  hi Bold cterm=bold ctermfg=NONE ctermbg=NONE gui=bold guifg=NONE guibg=NONE
  hi Italic cterm=italic ctermfg=NONE ctermbg=NONE gui=italic guifg=NONE guibg=NONE
  hi Underlined cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE
  hi Tag cterm=underline ctermfg=5 ctermbg=NONE gui=underline guifg=#af87af guibg=NONE
  hi Error cterm=bold,reverse ctermfg=9 ctermbg=NONE gui=bold,reverse guifg=#d787af guibg=NONE
  hi Todo cterm=bold,reverse ctermfg=6 ctermbg=NONE gui=bold,reverse guifg=#87afaf guibg=NONE
  hi NormalFloat cterm=NONE ctermfg=NONE ctermbg=0 gui=NONE guifg=NONE guibg=#444444
  hi StatusLine cterm=NONE ctermfg=7 ctermbg=0 gui=NONE guifg=#d0d0d0 guibg=#444444
  hi StatusLineNC cterm=NONE ctermfg=3 ctermbg=0 gui=NONE guifg=#af8787 guibg=#303030
  hi Pmenu cterm=NONE ctermfg=7 ctermbg=0 gui=NONE guifg=#a8a8a8 guibg=#1c1c1c
  hi PmenuSel cterm=reverse ctermfg=3 ctermbg=NONE gui=reverse guifg=#af8787 guibg=NONE
  hi PmenuSbar cterm=reverse ctermfg=0 ctermbg=NONE gui=reverse guifg=#303030 guibg=NONE
  hi PmenuThumb cterm=reverse ctermfg=6 ctermbg=NONE gui=reverse guifg=#87afaf guibg=NONE
  hi WildMenu cterm=bold,reverse ctermfg=11 ctermbg=NONE gui=bold,reverse guifg=#d7af87 guibg=NONE
  hi Title cterm=italic,bold ctermfg=6 ctermbg=NONE gui=italic,bold guifg=#87afaf guibg=NONE
  hi SpecialKey cterm=NONE ctermfg=8 ctermbg=NONE gui=NONE guifg=#808080 guibg=NONE
  hi NonText cterm=italic ctermfg=3 ctermbg=NONE gui=italic guifg=#af8787 guibg=NONE
  hi Folded cterm=italic ctermfg=3 ctermbg=0 gui=italic guifg=#af8787 guibg=#1c1c1c
  hi EndOfBuffer cterm=NONE ctermfg=4 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
  hi Search cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#000000 guibg=#87afaf
  hi IncSearch cterm=bold ctermfg=0 ctermbg=11 gui=bold guifg=#000000 guibg=#d7af87
  hi QuickFixLine cterm=bold ctermfg=NONE ctermbg=0 gui=bold guifg=NONE guibg=#303030
  hi Conceal cterm=NONE ctermfg=4 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
  hi Cursor cterm=NONE ctermfg=0 ctermbg=7 gui=NONE guifg=#000000 guibg=#d0d0d0
  hi lCursor cterm=NONE ctermfg=0 ctermbg=7 gui=NONE guifg=#000000 guibg=#d0d0d0
  hi CursorIM cterm=NONE ctermfg=0 ctermbg=7 gui=NONE guifg=#000000 guibg=#d0d0d0
  hi Directory cterm=NONE ctermfg=4 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
  hi ErrorMsg cterm=bold,reverse ctermfg=9 ctermbg=0 gui=bold,reverse guifg=#d787af guibg=#000000
  hi WarningMsg cterm=bold,reverse ctermfg=11 ctermbg=0 gui=bold,reverse guifg=#d7af87 guibg=#000000
  hi ModeMsg cterm=bold ctermfg=11 ctermbg=NONE gui=bold guifg=#d7af87 guibg=NONE
  hi SpellBad cterm=bold,reverse ctermfg=9 ctermbg=NONE gui=bold,reverse guifg=#d787af guibg=NONE
  hi DiffAdd cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#000000 guibg=#87afaf
  hi DiffDelete cterm=NONE ctermfg=9 ctermbg=9 gui=NONE guifg=#d787af guibg=#d787af
  hi DiffChange cterm=NONE ctermfg=0 ctermbg=4 gui=NONE guifg=#000000 guibg=#87afd7
  hi DiffText cterm=bold ctermfg=0 ctermbg=11 gui=bold guifg=#000000 guibg=#d7af87
  hi DiffAdded cterm=bold ctermfg=6 ctermbg=0 gui=bold guifg=#87afaf guibg=#1c1c1c
  hi DiffRemoved cterm=bold ctermfg=9 ctermbg=0 gui=bold guifg=#d787af guibg=#1c1c1c
  hi ColorColumn cterm=NONE ctermfg=NONE ctermbg=0 gui=NONE guifg=NONE guibg=#1c1c1c
  hi CursorColumn cterm=NONE ctermfg=NONE ctermbg=0 gui=NONE guifg=NONE guibg=#1c1c1c
  hi CursorLine cterm=NONE ctermfg=NONE ctermbg=0 gui=NONE guifg=NONE guibg=#1c1c1c
  hi Visual cterm=NONE ctermfg=NONE ctermbg=0 gui=NONE guifg=NONE guibg=#303030
  hi VisualNOS cterm=NONE ctermfg=NONE ctermbg=0 gui=NONE guifg=NONE guibg=#303030
  hi VertSplit cterm=NONE ctermfg=8 ctermbg=NONE gui=NONE guifg=#808080 guibg=NONE
  hi LineNr cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi CursorLineNr cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi LineNrAbove cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi LineNrBelow cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi FoldColumn cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi SignColumn cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi MatchParen cterm=bold ctermfg=0 ctermbg=6 gui=bold guifg=#000000 guibg=#87afaf
  hi TSConstMacro cterm=bold ctermfg=9 ctermbg=NONE gui=bold guifg=#d787af guibg=NONE
  hi TSSymbol cterm=bold ctermfg=5 ctermbg=NONE gui=bold guifg=#af87af guibg=NONE
  hi TSField cterm=NONE ctermfg=7 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
  hi TSParameter cterm=NONE ctermfg=7 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
  hi TSVariable cterm=NONE ctermfg=7 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
  hi TSVariableBuiltin cterm=NONE ctermfg=4 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
  hi TSKeywordFunction cterm=NONE ctermfg=2 ctermbg=NONE gui=NONE guifg=#afd7af guibg=NONE
  hi TSPunctBracket cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi TSText cterm=NONE ctermfg=7 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
  hi TSEmphasis cterm=italic ctermfg=7 ctermbg=NONE gui=italic guifg=#d0d0d0 guibg=NONE
  hi TSUnderline cterm=underline ctermfg=7 ctermbg=NONE gui=underline guifg=#d0d0d0 guibg=NONE
  hi TSStrike cterm=underline ctermfg=8 ctermbg=NONE gui=underline guifg=#808080 guibg=NONE
  hi TSStrong cterm=bold ctermfg=7 ctermbg=NONE gui=bold guifg=#d0d0d0 guibg=NONE
  hi TSTitle cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  hi TSError cterm=NONE ctermfg=1 ctermbg=NONE gui=NONE guifg=#d7005f guibg=NONE
  hi vimCommentTitle cterm=italic ctermfg=7 ctermbg=NONE gui=italic guifg=#a8a8a8 guibg=NONE
  hi markdownCode cterm=NONE ctermfg=3 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
  finish
endif
hi Normal cterm=NONE ctermfg=252 ctermbg=16 gui=NONE guifg=#d0d0d0 guibg=#000000
hi Constant cterm=NONE ctermfg=175 ctermbg=NONE gui=NONE guifg=#d787af guibg=NONE
hi String cterm=NONE ctermfg=151 ctermbg=NONE gui=NONE guifg=#afd7af guibg=NONE
hi Identifier cterm=NONE ctermfg=110 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
hi Statement cterm=NONE ctermfg=139 ctermbg=NONE gui=NONE guifg=#af87af guibg=NONE
hi Comment cterm=italic ctermfg=244 ctermbg=NONE gui=italic guifg=#808080 guibg=NONE
hi Ignore cterm=NONE ctermfg=244 ctermbg=NONE gui=NONE guifg=#808080 guibg=NONE
hi Bold cterm=bold ctermfg=NONE ctermbg=NONE gui=bold guifg=NONE guibg=NONE
hi Italic cterm=italic ctermfg=NONE ctermbg=NONE gui=italic guifg=NONE guibg=NONE
hi Underlined cterm=underline ctermfg=NONE ctermbg=NONE gui=underline guifg=NONE guibg=NONE
hi Tag cterm=underline ctermfg=139 ctermbg=NONE gui=underline guifg=#af87af guibg=NONE
hi Error cterm=bold,reverse ctermfg=175 ctermbg=NONE gui=bold,reverse guifg=#d787af guibg=NONE
hi Todo cterm=bold,reverse ctermfg=109 ctermbg=NONE gui=bold,reverse guifg=#87afaf guibg=NONE
hi NormalFloat cterm=NONE ctermfg=NONE ctermbg=238 gui=NONE guifg=NONE guibg=#444444
hi StatusLine cterm=NONE ctermfg=252 ctermbg=238 gui=NONE guifg=#d0d0d0 guibg=#444444
hi StatusLineNC cterm=NONE ctermfg=138 ctermbg=236 gui=NONE guifg=#af8787 guibg=#303030
hi Pmenu cterm=NONE ctermfg=248 ctermbg=234 gui=NONE guifg=#a8a8a8 guibg=#1c1c1c
hi PmenuSel cterm=reverse ctermfg=138 ctermbg=NONE gui=reverse guifg=#af8787 guibg=NONE
hi PmenuSbar cterm=reverse ctermfg=236 ctermbg=NONE gui=reverse guifg=#303030 guibg=NONE
hi PmenuThumb cterm=reverse ctermfg=109 ctermbg=NONE gui=reverse guifg=#87afaf guibg=NONE
hi WildMenu cterm=bold,reverse ctermfg=180 ctermbg=NONE gui=bold,reverse guifg=#d7af87 guibg=NONE
hi Title cterm=italic,bold ctermfg=109 ctermbg=NONE gui=italic,bold guifg=#87afaf guibg=NONE
hi SpecialKey cterm=NONE ctermfg=244 ctermbg=NONE gui=NONE guifg=#808080 guibg=NONE
hi NonText cterm=italic ctermfg=138 ctermbg=NONE gui=italic guifg=#af8787 guibg=NONE
hi Folded cterm=italic ctermfg=138 ctermbg=234 gui=italic guifg=#af8787 guibg=#1c1c1c
hi EndOfBuffer cterm=NONE ctermfg=110 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
hi Search cterm=bold ctermfg=16 ctermbg=109 gui=bold guifg=#000000 guibg=#87afaf
hi IncSearch cterm=bold ctermfg=16 ctermbg=180 gui=bold guifg=#000000 guibg=#d7af87
hi QuickFixLine cterm=bold ctermfg=NONE ctermbg=236 gui=bold guifg=NONE guibg=#303030
hi Conceal cterm=NONE ctermfg=110 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
hi Cursor cterm=NONE ctermfg=16 ctermbg=252 gui=NONE guifg=#000000 guibg=#d0d0d0
hi lCursor cterm=NONE ctermfg=16 ctermbg=252 gui=NONE guifg=#000000 guibg=#d0d0d0
hi CursorIM cterm=NONE ctermfg=16 ctermbg=252 gui=NONE guifg=#000000 guibg=#d0d0d0
hi Directory cterm=NONE ctermfg=110 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
hi ErrorMsg cterm=bold,reverse ctermfg=175 ctermbg=16 gui=bold,reverse guifg=#d787af guibg=#000000
hi WarningMsg cterm=bold,reverse ctermfg=180 ctermbg=16 gui=bold,reverse guifg=#d7af87 guibg=#000000
hi ModeMsg cterm=bold ctermfg=180 ctermbg=NONE gui=bold guifg=#d7af87 guibg=NONE
hi SpellBad cterm=bold,reverse ctermfg=175 ctermbg=NONE gui=bold,reverse guifg=#d787af guibg=NONE
hi DiffAdd cterm=bold ctermfg=16 ctermbg=109 gui=bold guifg=#000000 guibg=#87afaf
hi DiffDelete cterm=NONE ctermfg=175 ctermbg=175 gui=NONE guifg=#d787af guibg=#d787af
hi DiffChange cterm=NONE ctermfg=16 ctermbg=110 gui=NONE guifg=#000000 guibg=#87afd7
hi DiffText cterm=bold ctermfg=16 ctermbg=180 gui=bold guifg=#000000 guibg=#d7af87
hi DiffAdded cterm=bold ctermfg=109 ctermbg=234 gui=bold guifg=#87afaf guibg=#1c1c1c
hi DiffRemoved cterm=bold ctermfg=175 ctermbg=234 gui=bold guifg=#d787af guibg=#1c1c1c
hi ColorColumn cterm=NONE ctermfg=NONE ctermbg=234 gui=NONE guifg=NONE guibg=#1c1c1c
hi CursorColumn cterm=NONE ctermfg=NONE ctermbg=234 gui=NONE guifg=NONE guibg=#1c1c1c
hi CursorLine cterm=NONE ctermfg=NONE ctermbg=234 gui=NONE guifg=NONE guibg=#1c1c1c
hi Visual cterm=NONE ctermfg=NONE ctermbg=236 gui=NONE guifg=NONE guibg=#303030
hi VisualNOS cterm=NONE ctermfg=NONE ctermbg=236 gui=NONE guifg=NONE guibg=#303030
hi VertSplit cterm=NONE ctermfg=244 ctermbg=NONE gui=NONE guifg=#808080 guibg=NONE
hi LineNr cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi CursorLineNr cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi LineNrAbove cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi LineNrBelow cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi FoldColumn cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi SignColumn cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi MatchParen cterm=bold ctermfg=16 ctermbg=109 gui=bold guifg=#000000 guibg=#87afaf
hi TSConstMacro cterm=bold ctermfg=175 ctermbg=NONE gui=bold guifg=#d787af guibg=NONE
hi TSSymbol cterm=bold ctermfg=139 ctermbg=NONE gui=bold guifg=#af87af guibg=NONE
hi TSField cterm=NONE ctermfg=252 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
hi TSParameter cterm=NONE ctermfg=252 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
hi TSVariable cterm=NONE ctermfg=252 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
hi TSVariableBuiltin cterm=NONE ctermfg=110 ctermbg=NONE gui=NONE guifg=#87afd7 guibg=NONE
hi TSKeywordFunction cterm=NONE ctermfg=151 ctermbg=NONE gui=NONE guifg=#afd7af guibg=NONE
hi TSPunctBracket cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi TSText cterm=NONE ctermfg=252 ctermbg=NONE gui=NONE guifg=#d0d0d0 guibg=NONE
hi TSEmphasis cterm=italic ctermfg=252 ctermbg=NONE gui=italic guifg=#d0d0d0 guibg=NONE
hi TSUnderline cterm=underline ctermfg=252 ctermbg=NONE gui=underline guifg=#d0d0d0 guibg=NONE
hi TSStrike cterm=underline ctermfg=244 ctermbg=NONE gui=underline guifg=#808080 guibg=NONE
hi TSStrong cterm=bold ctermfg=252 ctermbg=NONE gui=bold guifg=#d0d0d0 guibg=NONE
hi TSTitle cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
hi TSError cterm=NONE ctermfg=161 ctermbg=NONE gui=NONE guifg=#d7005f guibg=NONE
hi vimCommentTitle cterm=italic ctermfg=248 ctermbg=NONE gui=italic guifg=#a8a8a8 guibg=NONE
hi markdownCode cterm=NONE ctermfg=138 ctermbg=NONE gui=NONE guifg=#af8787 guibg=NONE
