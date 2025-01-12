local M = {}

local luaVersion = _VERSION:gsub('Lua ', '')
local shareDir = vim.fs.joinpath(os.getenv 'HOME', '.luarocks', 'share', 'lua', luaVersion)
local manifestFile = vim.fs.joinpath(os.getenv 'HOME', '.luarocks', 'lib', 'luarocks', 'rocks-5.1', 'manifest')
local shFmt = [[sh -c ">/dev/null 2>/tmp/.nvim_luarock_err.log luarocks --local --lua-version='%s' install %s %s"]]

function M.setup()
  if package.path:find(vim.pesc(shareDir)) then return end
  -- print('adding luarocks shared dir to package.path')
  package.path = package.path
      .. ';' .. vim.fs.joinpath(shareDir, '?.lua')
      .. ';' .. vim.fs.joinpath(shareDir, '?', 'init.lua')
end

function M.installRock(rock)
  if not vim.fn.executable 'luarocks' then
    vim.notify("'luarocks' is not installed!", vim.log.levels.ERROR)
    return false
  end
  local shCmd = string.format(shFmt, luaVersion, rock.withArgs or ' ', rock[1] or rock)
  print(string.format('Installing rock: %q', rock[1] or rock))
  vim.notify(shCmd, vim.log.levels.DEBUG)
  vim.api.nvim__redraw { flush = true }
  local exit = os.execute(string.format(shCmd, luaVersion, rock))
  if exit == 0 then return true end
  -- handle errors
  local fd = assert(vim.uv.fs_open('/tmp/.nvim_luarock_err.log', 'r', 256))
  local data = assert(vim.uv.fs_read(fd, assert(vim.uv.fs_fstat(fd)).size, 0))
      :gsub('\n', '\n >> ')
  assert(vim.uv.fs_close(fd))
  vim.notify(string.format(
    'Error installing lua rock: %q; see error log:\n >> %s',
    rock, data), vim.log.levels.ERROR)
  return false
end

function M.ensureRocks(rocks, cb)
  local manifest = {}
  local fd = vim.uv.fs_open(manifestFile, 'r', 256)
  if fd ~= nil then
    local data = assert(vim.uv.fs_read(fd, assert(vim.uv.fs_fstat(fd)).size, 0))
    assert(vim.uv.fs_close(fd))
    local f = assert(loadstring(data))
    setfenv(f, manifest)
    f()
  end
  local repo = manifest.repository or {}
  vim.iter(rocks)
      :each(function(dep, _)
        if repo[dep[1] or dep] == nil then
          M.installRock(dep)
        end
      end)
  if cb then cb() end
end

return M
