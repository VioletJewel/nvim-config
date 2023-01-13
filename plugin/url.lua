-- Author: Violet
-- Last Change: 05 June 2022

local map = require'utils'.map

-- select url before cursor
map{ '<plug>(UrlPrev)', '<cmd>call url#UrlSelect(0, v:count1)<cr>', modes='nx' }

-- select url after cursor
map{ '<plug>(UrlNext)', '<cmd>call url#UrlSelect(1, v:count1)<cr>', modes='nx' }

-- open url under cursor
map{ 'gx', [[<cmd>execute 'silent !xdg-open' '"'..escape(expand('<cfile>'), '\"$')..'"'<cr>]] }
map{ 'gx', '<cmd>call url#V_gx()<cr>', modes='x' }

map{ 'gX', [[<cmd>call url#GX('"'..escape(expand('<cfile>')..'"', '\"$'))<cr>]] }
map{ 'gX', '<cmd>call url#GX()<cr>', modes='x' }

-- maybe move to maps.lua
map{ '<leader>u', '<plug>(UrlNext)', modes='nx' }
map{ '<leader>U', '<plug>(UrlPrev)', modes='nx' }

