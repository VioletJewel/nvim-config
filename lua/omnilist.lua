local M = {}

Omnilist = {}

-- eg: after/ftplugin/myfiletype.lua
-- vim.bo.omnifunc = require 'omnilist'.omnifunc { 'someword', 'another', 'etc' }
function M.omnifunc(words, match, ft)
  if ft == nil then
    ft = #vim.bo.filetype > 0 and vim.bo.filetype or '_' .. vim.api.nvim_get_current_buf()
  end
  if not Omnilist[ft] then
    if match == nil then
      match = '[A-Za-z.]+'
    end
    if not match:find '%$$' then
      match = match .. '$'
    end
    Omnilist[ft] = function(findstart, base)
      if findstart == 1 then
        local col = vim.fn.col '.' - 1
        return col - #(vim.fn.getline '.':sub(1, col):match(match) or '')
      end
      -- print('base', base)
      return vim.iter(words)
          :filter(function(word) return word:sub(1, #base) == base end)
          :totable()
    end
  end
  return 'v:lua.Omnilist.' .. ft
end

return M
