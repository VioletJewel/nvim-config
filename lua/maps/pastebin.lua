local M = {}

local c_v = string.char(22)

local regMap = {
  char  = { t = 'v', l = "'[", r = "']" },
  line  = { t = 'V', l = "'[", r = "']" },
  v     = { t = 'v', l = 'v',  r = '.'  },
  [c_v] = { t = c_v, l = 'v',  r = '.'  },
  V     = { t = 'V', l = 'v',  r = '.'  },
}

function _Paste(type)
  local args = regMap[type] or regMap.line
  local lines = vim.fn.getregion(
    vim.fn.getpos(args.l),
    vim.fn.getpos(args.r),
    { type = args.t }
  )
  local proc = io.popen("curl -N -F'file=@-' https://0x0.st", 'w')
  proc:write(table.concat(lines, '\n'))
  local lines = {}
  local line = proc:read()
  proc:flush()
  while line ~= nil do
    lines[#lines+1] = line
    line = proc:read()
  end
  proc:close()
  vim.fn.setreg('+', table.concat(lines, '\n'), vim.log.levels.INFO)
end

function M.pasteop()
  vim.go.opfunc = 'v:lua._Paste'
  vim.api.nvim_feedkeys('g@', 'L', false)
end

function M.pastevis()
  _Paste(vim.fn.visualmode())
end

return M
