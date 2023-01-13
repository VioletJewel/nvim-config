-- Author: Violet
-- Last Change: 27 June 2022

local map = require'utils'.map

map{ 'il', '<cmd>normal! g_v^<cr>', modes='xo',
  '<cmd>normal! g_v^<cr>' }

map{ 'al', '<cmd>normal! m`$v0<cr>', modes='xo',
  '<cmd>normal! m`$v0<cr>' }


map{ 'id', '<cmd>normal! G$Vgg0<cr>', modes='xo',
  '<cmd>normal! G$Vgg0<cr>' }


map{ 'go', '<cmd>call textobjs#visualGoOther(0)<cr>', modes='x',
  '<cmd>call textobjs#visualGoOther(0)<cr>' }

map{ 'gO', '<cmd>call textobjs#visualGoOther(1)<cr>', modes='x',
  '<cmd>call textobjs#visualGoOther(1)<cr>' }


map{ 'gl', '<cmd>call textobjs#visualGoLine(0)<cr>', modes='x',
  '<cmd>call textobjs#visualGoLine(0)<cr>' }

map{ 'gL', '<cmd>call textobjs#visualGoLine(1)<cr>', modes='x',
  '<cmd>call textobjs#visualGoLine(1)<cr>' }


map{ 'in', '<cmd>call textobjs#inNumber()<cr>', modes='xo',
  '<cmd>call textobjs#inNumber()<cr>' }

map{ 'an', '<cmd>call textobjs#aroundNumber()<cr>', modes='xo',
  '<cmd>call textobjs#aroundNumber()<cr>' }


map{ 'ii', '<cmd>call textobjs#inIndentation()<cr>', modes='xo',
  '<cmd>call textobjs#inIndentation()<cr>' }

map{ 'ai', '<cmd>call textobjs#aroundIndentation()<cr>', modes='xo',
  '<cmd>call textobjs#aroundIndentation()<cr>' }


