-- Author: Violet
-- Last Change: 19 September 2023

local function vca(ab) -- cabbrev hack for v{cmd} -> vert {cmd} at beginning of line only
  return string.format("<#ca> <expr> v%s getcmdline() == 'v%s' && getcmdtype() == ':' && getcmdpos() is %d ? 'vert %s' : '%s'", ab, ab, #ab+2, ab, ab)
end

require'utils'.mapall{
  '<#!a> unkown unknown',

  vca'sb',
  vca'h',
  vca'sn',
  vca'spr',
  vca'sbn',
  vca'sbp',

  vca'sb#',
  vca'h#',
  vca'sn#',
  vca'spr#',
  vca'sbn#',
  vca'sbp#',
}
