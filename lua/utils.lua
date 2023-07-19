-- Author: Violet
-- Last Change: 19 July 2023

local utils = {}

local function pop(tab, key)
  local ret = tab[key]
  tab[key] = nil
  return ret
end

function utils.map(opts)
  local lhs = (pop(opts, 1) or pop(opts, 'lhs')):gsub('<[lL]>', '<leader>'):gsub('<[lL][lL]>', '<localleader>')
  local rhs = pop(opts, 2) or pop(opts, 'rhs') or ''
  local desc = pop(opts, 3) or pop(opts, 'desc')
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

function utils.augroup(aug, skipcreate)
  local group = vim.api.nvim_create_augroup(aug, { clear = not skipcreate })
  return function(evt, opts)
    if type(evt) == 'string' and evt:match',' then
      -- split event if str w commas: 'Foo,Bar' => {'Foo','Bar'}
      local evts = evt
      evt = {}
      for e in evts:gmatch'[^,]+' do
        evt[#evt+1] = e
      end
    end
    if opts then
      if type(opts.pattern) == 'string' and opts.pattern:match',' then
        -- split opts.pattern if str w commas: '*.txt,*.md' => {'*.txt', '*.md'}
        local pats = opts.pattern
        opts.pattern = {}
        for p in pats:gmatch'[^,]' do
          opts.pattern[#opts.pattern+1] = p
        end
      end
      if not opts.group then
        -- add autocmd to group
        opts.group = group
      end
    end
    return vim.api.nvim_create_autocmd(evt, opts)
  end
end

return utils
