local fmrs = {}
local llen = 30

function Foldtext()
  local l1 = vim.fn.getline(vim.v.foldstart)
  -- local l2 = vim.fn.getline(vim.v.foldend)
  if vim.wo.foldmethod == 'marker' then
    local f1, f2
    local fmr = fmrs[vim.wo.foldmarker]
    if fmr == nil then
      fmr = vim.wo.foldmarker
      local com = fmr:find ','
      f1 = fmr:sub(1, com - 1):gsub('[][%%.+*]', '%%%1')
      f2 = fmr:sub(com + 1):gsub('[][%%.+*]', '%%%1')
    else
      f1 = fmr[1]
      f2 = fmr[2]
    end
    local cms = vim.bo.commentstring
    cms = cms:sub(1, cms:find '%s*%%s' - 1)
    l1 = l1:gsub(cms .. '%s*' .. f1 .. '%d*', ''):gsub('%s*' .. f1 .. '%d*', '')
    -- l2 = l2:gsub(cms .. '%s*' .. f2 .. '%d*', ''):gsub('%s*' .. f2 .. '%d*', ''):gsub('^%s+', '')
    if l1:len() > llen then l1 = l1:sub(1, llen) .. '...' end
    -- if l2:len() > llen then l2 = l2:sub(1, llen) .. '...' end
  end
  return string.format('%-35s +%3d', l1:gsub('^ ? ?', '|>'), vim.v.foldend - vim.v.foldstart) --, l2)
end

vim.opt.foldtext = 'v:lua.Foldtext()'
