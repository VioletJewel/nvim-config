-- Author: Violet
-- Last Change: 19 September 2023

local utils = {}

local lastcolor = nil
function utils.color(color)
  if lastcolor ~= color then
    lastcolor = pcall(vim.cmd.colorscheme, color) and color or nil
  end
end

local function pop(tab, key)
  local ret = tab[key]
  tab[key] = nil
  return ret
end

local mapargs = {
  buffer  = 'buffer',  buf  = 'buffer',
  nowait  = 'nowait',  nw   = 'nowait',
  silent  = 'silent',  sil  = 'silent',
  noremap = 'noremap', nore = 'noremap',
  remap   = 'remap',   re   = 'remap',
  script  = 'script',
  expr    = 'expr',
  unique  = 'unique',
  replace_keycodes = true,
  desc = true,
  callback = true,
}

-- Example:
--  > mapall{
--  ..  { '<leader>x', '"leader x"', mode={'i','s'}, silent=true, expr=true },
--  ..  '<#is,sil,expr> <l>y "leader y"',
--  ..}
function utils.mapall(maps)
  for _,map in ipairs(maps) do
    if type(map) == 'table' or type(map) == 'string' and not map:find'^%s*$' then
      utils.map(type(map) == 'string' and {map} or map)
    end
  end
end

-- Examples:
--  > map{ '<l>' }
--  > map{ '<leader> <nop>', desc='make leader noop' }
--
--  > map{ '<l>h', "<cmd>unsil echo 'hi'<cr>", sil=true, mode='ni' }
--  > map{ '<#ni,sil> <l>h <cmd>unsil echo 'hi'<cr>" }
function utils.map(opts)
  local lhs, rhs, pos, mode, args
  args = {}

  if type(opts) ~= 'table' then opts = {opts} end
  lhs = table.remove(opts, 1)

	pos = lhs:find'%S'
	for pre,arg,after in lhs:gmatch"()(%b<>)%s*()" do
    local targs = {}
    local mfail = false
    if lhs:sub(pos,pre):match('%S') ~= '<' then break end
    arg = arg:sub(2, -2)
    for a in arg:gmatch'([^,]+)' do
      if a:find'^#' then
        mode = a:sub(2)
      else
        if mapargs[a] == nil or type(mapargs[a]) == 'bool' then
          mfail = true
          break
        end
        targs[#targs+1] = a
      end
    end
    if mfail then break end
    for _,a in ipairs(targs) do
      args[mapargs[a]] = true
    end
    pos = after
	end
  lhs = lhs:sub(pos)

  lhs, rhs = lhs:match'^(%S+)%s*(.*)'
  if #rhs == 0 then rhs = table.remove(opts, 1) or '' end
  lhs = lhs:gsub('<([lL])>', '<%1eader>'):gsub('<([lL])([lL])>', '<%1ocal%2eader>')

  if mode == nil then mode = pop(opts, 'mode') end
  if type(mode) == 'string' then
    if #mode > 1 and not (#mode == 2 and (mode == 'ia' or mode == 'ca' or mode == '!a')) then
      local smode = mode
      mode = {}
      local mp = nil
      for i = 1, #smode do
        local m = smode:sub(i, i)
        if m == 'a' and (mp == 'o' or mp == 'c' or mp == '!') then
          mode[#mode] = mode[#mode] .. m
        elseif m == ' ' then
        else
          mode[#mode+1] = m
        end
        mp = m
      end
    end
  elseif not mode then
    mode = 'n'
  end

  for k,v in pairs(opts) do
    if type(k) == 'string' and mapargs[k] then
      args[type(mapargs[k]) == 'boolean' and k or mapargs[k]] = v
    end
  end

  vim.keymap.set(mode, lhs, rhs, args)
end

function utils.augroup(aug, skipcreate)
  local group = vim.api.nvim_create_augroup(aug, { clear = not skipcreate })
  return function(opts)
    local evt = table.remove(opts, 1)
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
