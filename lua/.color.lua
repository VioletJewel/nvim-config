
local cube = {0,95,135,175,215,255}

local function mincube(v)
  local i,c = next(cube)
  local min = math.abs(v-c)
  local idx = i
  while i do
    c = math.abs(v-c)
    if c < min then
      min = c
      idx = i
    end
    i,c = next(cube,i)
  end
  return cube[idx]
end

local function nearest(n)
  local r, g, b = bit.band(n,0xff0000)/65536, bit.band(n,0xff00)/256, bit.band(n,0xff)
  return mincube(r)*65536 + mincube(g)*256 + mincube(b)
end

local out = ''
for r = 0,0xff,20 do
  for g = 0,0xff,20 do
    for b = 0,0xff,20 do
      local n = r*65536 + g*256 + b
      local m = nearest(n)
      out = out .. string.format([[
<div style="display: block">
  <div style="display: inline-block; width: 80px; height: 18px;">#%06x</div>
  <div style="display: inline-block; width: 80px; height: 18px; background-color: #%06x;" />
</div>
<div style="display: block">
  <div style="display: inline-block; width: 80px; height: 18px;">#%06x</div>
  <div style="display: inline-block; width: 80px; height: 18px; background-color: #%06x;" />
</div>
<hr/>
]], n, n, m, m)
    end
  end
end

vim.fn.setreg('+', out)

