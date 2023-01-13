-- Author: Violet
-- Last Change: 13 January 2023

local utils = {}

function utils.try(fun, ...)
  _, ret = xpcall(fun, function(err)
    print("Error", err)
  end, ...)
  return ret
end

local function pop(tab, key)
  local ret = tab[key]
  tab[key] = nil
  return ret
end

function utils.map(opts)
  local lhs = (pop(opts, 1) or pop(opts, lhs)):gsub('<[lL]>', '<leader>'):gsub('<[lL][lL]>', '<localleader>')
  local rhs = pop(opts, 2) or pop(opts, 'rhs') or ''
  local desc = pop(opts, 3)
  local modes = pop(opts, 'modes') or 'n'
  if type(modes) == 'string' then
    if #modes > 1 then
      mode = {}
      for i = 1, #modes do
        mode[#mode+1] = modes:sub(i, i)
      end
    elseif #modes == 0 then
      mode = 'n'
    else
      mode = modes
    end
  end
  if desc then opts.desc = desc end
  vim.keymap.set(mode, lhs, rhs, opts)
end

function utils.buildaugroup(aug, skipcreate)
  local auid = vim.api.nvim_create_augroup(aug, { clear = not skipcreate })
  return function(opts)
    local evt = pop(opts, 1) or pop(opts, 'event')
    local cmd = pop(opts, 2) or pop(opts, 'command')
    local desc = pop(opts, 3)
    opts.group = auid
    local ex, cb -- ex command, lua callback
    if type(cmd) == 'function' then
      opts.callback = cmd
      opts.command = nil
    else
      opts.command = cmd
      opts.callback = nil
    end
    if type(evt) == 'string' and evt:match',' then
      local evts = evt
      evt = {}
      for e in evts:gmatch'[^,]+' do
        evt[#evt+1] = e
      end
    end
    if desc then opts.desc = desc end
    vim.api.nvim_create_autocmd(evt, opts)
  end
end

return utils
