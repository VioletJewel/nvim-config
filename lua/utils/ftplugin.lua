local M = {}

--- Save and reset maps, commands, and options for a filetype
--- 
--- Usage:
--- ```lua
---   -- in after/ftplugin/myfiletype.lua:
---   require 'utils.ftplugin'.addMap('n', '<F12>', "<Cmd>echo 'hi'<CR>")
---   require 'utils.ftplugin'.addCmd('Hello', "echo 'hi'")
---   require 'utils.ftplugin'.addOpt('foldmarker', '<<<,>>>')
--- ```
---
--- A cleanup function that resets these local maps/commands/options is injected
--- into b:undo_ftplugin


--- @param bufnr? number
local function ensureBufnr(bufnr)
  return type(bufnr) == 'number' and bufnr > 0 and bufnr or vim.api.nvim_get_current_buf()
end

--- lookup table for added
--- @type { [string]: any }
local lookup = {}
do
  local mt = {
    __index = function(tbl, bufnr)
      local b = vim.b[bufnr]
      b.undo_ftplugin = "call v:lua.require('utils.ftplugin').undoFtplugin(" ..
          bufnr .. ")" .. (b.undo_ftplugin and '|' .. b.undo_ftplugin or '')
      local t = { maps = {}, opts = {}, cmds = {} }
      tbl[bufnr] = t
      return t
    end
  }
  setmetatable(lookup, mt)
end

--- @param mode string|string[]
--- @param lhs string
--- @param rhs string|function
--- @param opts? table can contain `buffer` to set for a particular buffer
function M.addMap(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = ensureBufnr(opts.buffer)
  lookup[opts.buffer].maps[mode .. ' ' .. lhs] = { mode, lhs, rhs, opts }
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- @param name string
--- @param val any
--- @param bufnr? number
function M.addOpt(name, val, bufnr)
  bufnr = ensureBufnr(bufnr)
  vim.opt_local[name] = val
  lookup[bufnr].opts[name] = val
end

--- @param name string
--- @param cmd string|function
--- @param opts? table
--- @param bufnr? number
function M.addCmd(name, cmd, opts, bufnr)
  bufnr = ensureBufnr(bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, name, cmd, opts or {})
  lookup[bufnr].cmds[name] = cmd
end

--- @param bufnr? number
function M.undoFtplugin(bufnr)
  bufnr = ensureBufnr(bufnr)
  for _, map in pairs(lookup[bufnr].maps) do
    vim.keymap.del(map[1], map[2], { buffer = bufnr })
  end
  for name, _ in pairs(lookup[bufnr].opts) do
    vim.opt_local[name] = vim.api.nvim_get_option_info2(name, {}).default
  end
  for name, _ in pairs(lookup[bufnr].cmds) do
    vim.api.nvim_buf_del_user_command(bufnr, name)
  end
end

return M
