local function req(file)-->
  local ok, res = pcall(require, file)
  if not ok then
    vim.notify(string.format('Error loading %q => %s', file, res), vim.log.levels.ERROR)
    return
  end
  return res
end--<

req 'opts'       -- ./lua/opts.lua
req 'foldtext'   -- ./lua/foldtext.lua
req 'plugins'    -- ./lua/plugins/init.lua
req 'statusline' -- ./lua/statusline.lua
