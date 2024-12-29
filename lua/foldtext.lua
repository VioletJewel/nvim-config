local fmrs = {}
local llen = 74
local fmt = '%-' .. llen .. 's +%3d'

function Foldtext()
  local l1 = vim.fn.getline(vim.v.foldstart)
  if vim.wo.foldmethod == 'marker' then
    local f1
    local fmr = fmrs[vim.wo.foldmarker]
    if fmr == nil then
      fmr = vim.wo.foldmarker
      local com = fmr:find ','
      f1 = fmr:sub(1, com - 1):gsub('[][%%.+*]', '%%%1')
    else
      f1 = fmr[1]
    end
    local cms = vim.bo.commentstring
    cms = cms:sub(1, cms:find '%s*%%s' - 1)
    l1 = l1:gsub(cms .. '%s*' .. f1 .. '%d*', ''):gsub('%s*' .. f1 .. '%d*', '')
    if l1:len() > llen then l1 = l1:sub(1, llen) .. '...' end
  end
  return string.format(fmt, l1:gsub('^ ? ?', '|>'), vim.v.foldend - vim.v.foldstart)
end

vim.opt.foldtext = 'v:lua.Foldtext()'
