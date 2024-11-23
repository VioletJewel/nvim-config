-- local folddash = '●'

-- local function tab2space(s)
--   return string.rep(' ', vim.bo.tabstop * s)
-- end

-- function Foldtext()
--   local line = vim.fn.getline(vim.v.foldstart)
--   line = line:gsub('^\t+', tab2space)
--   local _, b = line:find '^%s*'
--   local cms = vim.bo.commentstring:gsub('%s*%%s%s*', '')
--   if line:sub(b + 1, b + #cms) == cms then
--     b = b + #cms
--   end
--   local _, c = line:sub(b + 1):find '^%s*'
--   b = b + c
--   line = string.rep(folddash, vim.v.foldlevel) .. line:sub(b == 0 and 0 or b > #cms and #cms or b)
--   if line:match('^%s*[[({}]%W*$') then
--     return line .. ' … ' .. vim.fn.getline(vim.v.foldstart + 1):gsub('^%s+', '')
--   end
--   return line
-- end

-- vim.opt.foldtext = 'v:lua.Foldtext()'
