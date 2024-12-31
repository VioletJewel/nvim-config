local M = {}

function M.augroup(name, clear)-->
  --- Wrapper around nvim API's augroup and autocmd using a closure.
  -- local au = require'utils'.augroup'MyAugroup'
  -- au{'VimEnter', command='echo "hi"'}
  local group = vim.api.nvim_create_augroup(name, { clear = clear })
  return function(opts)
    local evt = table.remove(opts, 1)
    if type(evt) == 'string' then
      evt = vim.split(evt, ',')
      if #evt == 1 then evt = evt[1] end
    end
    if not opts.group then opts.group = group end
    return vim.api.nvim_create_autocmd(evt, opts)
  end
end--<

return M
