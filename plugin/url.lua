-- Author: Violet
-- Last Change: 09 September 2023

require'utils'.mapall{
  -- select url before cursor
  ':nx: <plug>(UrlPrev) <cmd>call url#UrlSelect(0, v:count1)<cr>',

  -- select url after cursor
  ':nx: <plug>(UrlNext) <cmd>call url#UrlSelect(1, v:count1)<cr>',

  -- open url under cursor
  [[    gx <cmd>execute 'silent !xdg-open' '"'..escape(expand('<cfile>'), '\"$')..'"'<cr>]],
  [[:x: gx <cmd>call url#V_gx()<cr>]],

  [[    gX <cmd>call url#GX('"'..escape(expand('<cfile>')..'"', '\"$'))<cr>]],
  [[:x: gX <cmd>call url#GX()<cr>]],

  ':nx: <leader>u <plug>(UrlNext)',
  ':nx: <leader>U <plug>(UrlPrev)',
}
