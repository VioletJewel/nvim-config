local M = {}

Omnilist = {}

-- -- tl;dr: put in, eg, after/ftplugin/myfiletype.lua
--
-- local ofu = require 'omnilist'.omnifunc
--
-- -- complete "someword", "another", "etc" with i_^x^o omnifunc completion
-- vim.bo.ofu =  ofu { 'someword', 'another', 'etc' }
--
-- -- -or- complete "word1"/"word2" and only match /[[:alpha:]]/
-- vim.bo.ofu = ofu({'word1','word2'}, '[A-Za-z]+')

--- @param words string[] list of words to complete; eg { 'a', 'b', 'c' }
--- @param match string   string pattern to match (lua string.match);
---                       default: '[A-Za-z.]+'
--- @param ft    string   can be any unique key; probably leave empty;
---                       default: (&ft or '_'.bufnr())
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
