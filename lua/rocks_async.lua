local luaVersion = _VERSION:gsub('Lua ', '')
---@diagnostic disable-next-line: param-type-mismatch
local rocksDir = vim.fs.joinpath(vim.fn.stdpath 'data', 'luarocks')
local tmpOut = '/tmp/.nvim_luarocks.out'
local tmpErr = '/tmp/.nvim_luarocks.err'
local rocksWin = { width = 80, height = 20, border = 4, minVPad = 10, minHPad = 20 }

-- Luarocks { 'search', 'foo' }
-- Luarocks { 'install', 'foo' }
function M.LuarocksRun(cmd)
  local bnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bnr, 0, 0, true, { 'luarocks ' .. table.concat(cmd, ' ') })

  local out, err = {}, {}
  local outind, errind = 1, 1
  local stdout, stderr = assert(vim.uv.new_pipe()), assert(vim.uv.new_pipe())
  vim.uv.spawn('luarocks', { ---@diagnostic disable-line: missing-fields
    stdio = { nil, stdout, stderr },
    args = { '--lua-version=' .. luaVersion, '--tree=' .. rocksDir }
  }, function(code)
    -- vim.uv.loop_close()
    -- if code ~= 0 then
    --   vim.api.nvim_buf_set_lines(0, -1, -1, true, { '', '== Errors == exit code: ' .. code, '' })
    --   vim.api.nvim_buf_set_lines(bnr, -1, -1, true, vim.iter(err):flatten(1):totable())
    --   vim.api.nvim_buf_set_lines(0, -1, -1, true, { '', '============', '' })
    -- end
    --   vim.api.nvim_buf_set_lines(bnr, -1, -1, true, vim.iter(out):flatten(1):totable())
  end)

  vim.uv.read_start(stdout, function(e, data)
    assert(not e, e)
    if data then
      out[outind] = data
      outind = outind + 1
    end
  end)

  vim.uv.read_start(stderr, function(e, data)
    assert(not e, e)
    if data then
      err[errind] = data
      errind = errind + 1
    end
  end)

  -- vim.uv.shutdown(stdout, function()
  --   vim.uv.close(handle, function()
  --     vim.api.nvim_buf_set_lines(0, 0, 0, true, { 'test' })
  --   end)
  -- end)

  vim.uv.walk(function(handle)
    if not handle:is_closing() then
      handle:close()
    end
  end)

  vim.uv.thread_join(vim.uv.thread_self())
  vim.api.nvim_buf_set_lines(0, 0, 0, true, { 'test' })

  vim.bo[bnr].modifiable = false
  vim.bo[bnr].readonly = true
  vim.keymap.set('n', 'q', function()
    vim.iter(vim.api.nvim_tabpage_list_wins(0))
        :each(function(winid)
          local winBnr = vim.api.nvim_win_get_buf(winid)
          if winBnr == bnr then
            vim.api.nvim_win_close(winid, true)
          end
        end)
  end)
  local w = math.min(vim.o.columns - rocksWin.border, math.max(rocksWin.width, vim.o.columns - rocksWin.minHPad))
  local h = math.min(vim.o.lines - rocksWin.border, math.max(rocksWin.height, vim.o.lines - rocksWin.minVPad))
  local l = math.floor((vim.o.columns - w) / 2 + .5)
  local t = math.floor((vim.o.lines - h) / 2 + .5) - 1
  vim.api.nvim_open_win(bnr, true,
    { relative = 'editor', width = w, height = h, col = l, row = t, style = 'minimal', border = 'single' })
end

-- function LuarocksInstall()
--   ;
-- end

-- :Rocks search foo
-- :Rocks install foo
vim.api.nvim_create_user_command('Rocks', function(opts) M.LuarocksRun(opts.fargs) end, {
  nargs = '+',
  desc = 'Interact with luarocks for neovim'
})
