
--- utility functions
-- @author Violet Jewel
-- @module utils
-- @alias M
local M = {}

--- Get OS name.
-- @treturn string the OS name (one of 'windows', 'linux', 'macos')
-- @function utils.osname
function M.osname()
  local binfmt = package.cpath:match"%p[\\|/]?%p(%a+)"
  if binfmt == 'dll' then
    return 'windows'
  elseif binfmt == 'so' then
    return 'linux'
  elseif binfmt == "dylib" then
    return 'macos'
  else
    return nil
  end
end

--- Wrapper around <code>vim.keymap.set()</code>.
--
--- <i>One positional argument:</i>
-- Modes, LHS, and RHS are derived from first non-space group, second non-space
-- group, and rest of string from <code>opts[1]</code>. If there are only two
-- non-space groups, RHS will be an empty string and act as <code><Nop></code>.
--
--- <i>Two positional arguments:</i>
-- <code>opts[2]</code> is assumed to be a lua function or string representing
-- RHS. Mode and LHS are still extracted from the first and second non-space
-- groups in <code>opts[1]</code>.
--
--- <i>Modes:</i>
-- If Modes is 'ia', 'ca', or '!a', this is treated as an abbreviation (in
-- insert, cmdline, or both resp.). Otherwise, it's treated as one or more
-- Modes. If there is more than one Mode, it is split into a table. Then Modes
-- is passed as the first param to <code>vim.keymap.set()</code>.
--
--- <i>LHS:</i>
-- If LHS has <code>'L'</code> or <code>'LL'</code> these are converted to
-- <code>'Leader'</code> or <code>'LocalLeader'</code> (resp.). After these two
-- substitutions, it's passed as-is as the second param to
-- <code>vim.keymap.set()</code>.
--
--- <i>RHS:</i>
-- As mentioned, this either comes from the <code>opts[2]</code> or the rest of
-- <code>opts[1]</code> after the first two non-space groups. This is to
-- accomodate lua funcitons, but it is passed as-is as the third param to
-- <code>vim.keymap.set()</code>.
--
--- <i>Opts:</i>
-- The kwargs (non-positional opts) in <code>opts</code> become the fourth param
-- passed to <code>vim.keymap.set()</code>.
--
-- @usage require'utils'.map{'nx <L>h <Cmd>echo "Hi"<cr>', desc='say hi'}
-- @usage require'utils'.map{'nx <L>H', function() print'Hi' end, desc='say hi'}
-- @tparam table opts table with 1 or 2 positional opt/opts and kwargs for
-- <code>vim</code>.keymap.set().
-- @function map
function M.map(opts)
  -- local function E(m) error(string.format('Error in utils.map (%s): %s', m, vim.inspect(opts))
  local lhs
  local modes = table.remove(opts, 1)
  local rhs = table.remove(opts, 1)
  if rhs == nil then
    modes, lhs, rhs = modes:match'^%s*(%S+)%s+(%S+)%s*(.*)'
  else
    modes, lhs = modes:match'^(%S+)%s+(%S+)$'
  end
  if lhs == nil then
    error('invalid map: '..vim.inspect(opts))
    return
  end
  if #modes > 1 and not modes:find'^[ic!]a$' then
    modes = vim.split(modes, '')
  end
  lhs = lhs:gsub('<[lL]>', '<Leader>'):gsub('<[lL][lL]>', '<LocalLeader>')
  vim.keymap.set(modes, lhs, rhs, opts)
end

--- Simple function that maps each map in a table to @{utils.map}.
-- @tparam (table|string)[] maps list of maps, each of which will be passed to @{utils.map}
function M.mapall(maps)
  vim.tbl_map(M.map, maps)
end

--- Wrapper around nvim API's augroup and autocmd using a closure.
-- @param name the name of the augroup to create or attach to.
-- @param (optional) clear should this augroup be cleared.
-- @treturn function a closure that will add an autocmd into the augroup and
-- auto-split the events.
-- @usage au = require'utils.augroup'MyAugroup' au('VimEnter', {command='echo "hi"'})
-- @function utils.augroup
function M.augroup(name, clear)
  local group = vim.api.nvim_create_augroup(name, {clear=clear})
  return function(evt, opts)
    if type(evt) == 'string' then
      evt = vim.split(evt, ',')
      if #evt == 1 then evt = evt[1] end
    end
    if not opts.group then opts.group = group end
    return vim.api.nvim_create_autocmd(evt, opts)
  end
end

return M

