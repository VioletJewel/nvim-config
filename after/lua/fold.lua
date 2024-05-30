
local folddash = '●'

local function tab2space(s)
  return string.rep(' ', vim.bo.tabstop * s:len())
end

local function dash()
  return ' '..string.rep(folddash, vim.v.foldlevel)
end

vim.g.foldtext = function()
  local line = vim.fn.getline(vim.v.foldstart):gsub('^\t+', tab2space)..dash()
  if line:match('^%s*[[({}]%W*$') then
    return line..' … '..vim.fn.getline(vim.v.foldstart+1):gsub('^%s+', '')
  end
  return line
end
