-- Author: Violet
-- Last Change: 12 September 2023

require'utils'.mapall{
  ':xo: il <cmd>normal! g_v^<cr>',
  ':xo: al <cmd>normal! m`$v0<cr>',
  ':xo: id <cmd>normal! G$Vgg0<cr>',
  ':x:  go <cmd>call textobjs#visualGoOther(0)<cr>',
  ':x:  gO <cmd>call textobjs#visualGoOther(1)<cr>',
  ':x:  gl <cmd>call textobjs#visualGoLine(0)<cr>',
  ':x:  gL <cmd>call textobjs#visualGoLine(1)<cr>',
  ':xo: in <cmd>call textobjs#inNumber()<cr>',
  ':xo: an <cmd>call textobjs#aroundNumber()<cr>',
  ':xo: ii <cmd>call textobjs#inIndentation()<cr>',
  ':xo: ai <cmd>call textobjs#aroundIndentation()<cr>',
}
