local M = {}

function M.shouldSplit()
  if vim.api.nvim_tabpage_list_wins(0) > 1 then
    return true
  end
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == '' and #vim.fn.undotree(buf).entries == 0 then
    return true
  end
end

return M
