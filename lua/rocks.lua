local luaVersion = _VERSION:gsub('Lua ', '')
---@diagnostic disable-next-line: param-type-mismatch
local rocksDir = vim.fs.joinpath(vim.fn.stdpath 'data', 'luarocks')
local tmpOut = '/tmp/.nvim_luarocks.out'
local tmpErr = '/tmp/.nvim_luarocks.err'
local rocksFmt = string.format(
  [[sh -c " >%s 2>%s luarocks --lua-version='%s' --tree='%s' %%s"]],
  tmpOut, tmpErr, luaVersion, rocksDir)
local rocksWin = { width = 80, height = 20, border = 4, minVPad = 10, minHPad = 20 }

local function readFile(path)
  local fd = assert(vim.uv.fs_open(path, "r", 256))
  local stat = assert(vim.uv.fs_fstat(fd))
  local data = assert(vim.uv.fs_read(fd, stat.size, 0))
  assert(vim.uv.fs_close(fd))
  return data
end

local M = {}

local function newBuf()
  local bnr = vim.api.nvim_create_buf(false, true)
  local b = vim.bo[bnr]
  local buf = {}
  function buf.insertLines(lineNr, lines)
    vim.api.nvim_buf_set_lines(bnr, lineNr, lineNr, true, lines)
  end

  function buf.appendLines(lines)
    vim.api.nvim_buf_set_lines(bnr, -1, -1, true, lines)
  end

  function buf.lock()
    b.modifiable = false
    b.readonly = true
  end

  function buf.unlock()
    b.modifiable = true
    b.readonly = false
  end

  function buf.setKeymap(mode, lhs, rhs, opts)
    opts = opts and opts or {}
    opts.buffer = bnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  function buf.openFloatWin()
    local w = math.min(vim.o.columns - rocksWin.border, math.max(rocksWin.width, vim.o.columns - rocksWin.minHPad))
    local h = math.min(vim.o.lines - rocksWin.border, math.max(rocksWin.height, vim.o.lines - rocksWin.minVPad))
    local l = math.floor((vim.o.columns - w) / 2)
    local t = math.floor((vim.o.lines - h) / 2) - vim.o.cmdheight
    vim.api.nvim_open_win(bnr, true,
      { relative = 'editor', width = w, height = h, col = l, row = t, style = 'minimal', border = 'single' })
  end

  buf.setKeymap('n', 'q', function() vim.api.nvim_win_hide(0) end)
  return buf
end

function M.setup()
  local rockDir = vim.fs.joinpath(rocksDir, 'share', 'lua', luaVersion)
  if not vim.uv.fs_access(rockDir, 'R') then
    vim.notify(string.format('Error loading rock %q', rockDir), vim.log.levels.ERROR)
    return
  end
  package.path = package.path
      .. ';' .. vim.fs.joinpath(rockDir, '?.lua')
      .. ';' .. vim.fs.joinpath(rockDir, '?', 'init.lua')
end

-- require 'rocks'.run '<cmd>'
function M.run(cmd, sil)
  local rocksCmd = rocksFmt:format(cmd)
  local exit = os.execute(rocksCmd)
  if sil then return exit end
  local data = readFile(exit == 0 and tmpOut or tmpErr)
  local buf = newBuf()
  buf.insertLines(0, { 'luarocks ' .. cmd, string.rep('=', #cmd + 9) })
  buf.appendLines(vim.split(data, '\n'))
  buf.lock()
  buf.openFloatWin()
  return exit
end

function M.ensure(rock)
  local rootrock = rock:gsub('%.nvim$', ''):gsub('^nvim%-', '') -- TODO
  local rockDir = vim.fs.joinpath(rocksDir, 'share', 'lua', luaVersion, rootrock)
  local stat = vim.uv.fs_stat(rockDir)
  if stat and stat.type == 'directory' then return 0 end
  print('luarocks install ' .. rock)
  vim.api.nvim__redraw { statusline = true }
  return M.run('install ' .. rock, true)
end

function M.ensureAll(rocks)
  return vim.iter(rocks)
      :filter(function(rock) return M.ensure(rock) ~= 0 end)
      :totable()
end

-- -- TODO
-- function M.install()
--   -- check if alr exists and exit
--   -- curl hererocks
--   -- install luarocks
--   print('not implemented')
-- end

local rocksCmplWords = {
  -- opts
  '-h,', '--help', '--version', '--dev', '--server', '--only-server',
  '--only-sources', '--namespace', '--lua-dir', '--lua-version', '--tree',
  '--local', '--global', '--no-project', '--force-lock', '--verbose',
  '--timeout',
  -- cmds
  'help', 'completion', 'build', 'config', 'doc', 'download', 'init',
  'LuaRocks', 'install', 'lint', 'list', 'make', 'new_version', 'pack', 'path',
  'purge', 'remove', 'search', 'show', 'test', 'unpack', 'upload', 'which',
  'write_rockspec',
}

-- :Rocks <cmd>
vim.api.nvim_create_user_command('Rocks', function(opts) M.run(opts.args) end, {
  nargs = 1,
  desc = 'Interact with luarocks for neovim',
  complete = function(lead, line, pos)
    local l = #line == pos and lead or line:gsub('.*%s(%w*)$', '%1')
    print(lead, l)
    local t = vim.iter(rocksCmplWords)
        :filter(function(word)
          return vim.startswith(word, l)
        end):totable()
    print(vim.inspect(t))
    return t
  end
})

return M
