function Foldtext()
  local l1 = vim.fn.getline(vim.v.foldstart)
  local l2 = vim.fn.getline(vim.v.foldend)
  if vim.wo.foldmethod == 'marker' then
    local fmr = vim.wo.foldmarker
    local com = fmr:find ','
    local cms = vim.bo.commentstring
    cms = cms:sub(1, cms:find '%s*%%s' - 1)
    local f1 = fmr:sub(1, com - 1):gsub('[][%%.+*]', '%%%1')
    local f2 = fmr:sub(com + 1):gsub('[][%%.+*]', '%%%1')
    l1 = l1:gsub(cms .. '%s*' .. f1, ''):gsub('%s*' .. f1, '')
    l2 = l2:gsub(cms .. '%s*' .. f2, ''):gsub('%s*' .. f2, ''):gsub('^%s+', '')
  end
  return string.format('%s (×%d) %s', l1:gsub('^ ? ?', '|>'), vim.v.foldend - vim.v.foldstart, l2)
end

vim.opt.foldtext = 'v:lua.Foldtext()'
