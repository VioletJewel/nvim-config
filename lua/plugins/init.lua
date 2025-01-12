local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  vim.fn.system({
    'git',
    'clone',
    "--filter=blob:none",
    'https://github.com/lewis6991/pckr.nvim',
    pckr_path
  })
end

vim.opt.rtp:prepend(pckr_path)

require 'utils.rocks'.setup()

---@diagnostic disable-next-line: param-type-mismatch
local plugd = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugins') .. '/'
local files = {}

do
  ---@diagnostic disable-next-line: param-type-mismatch
  local dir, err = vim.uv.fs_opendir(plugd, nil, 100)
  if dir == nil then
    vim.notify(string.format('Error opening plugin directory %q: %s', plugd, err), vim.log.levels.ERROR, {})
    return
  end
  local i = 1
  while true do
    local d = vim.uv.fs_readdir(dir)
    if d == nil then break end
    files[i] = d
    i = i + 1
  end
  vim.uv.fs_closedir(dir)
end

local specs = vim.iter(files)
    :flatten(1)
    :filter(function(p)
      return p.type == 'file' and p.name ~= 'init.lua' and not p.name:find '/init%.lua$' and p.name:find '%.lua'
    end)
    :map(function(p)
      local lf, err = loadfile(plugd .. p.name)
      if lf then return lf() end
      vim.notify(string.format('Error loading plugin file %q: %s', p.name, err), vim.log.levels.ERROR, {})
    end)

require 'pckr'.add(specs:flatten(1):totable())
