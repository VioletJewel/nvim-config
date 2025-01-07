local function req(file)-->
  local ok, res = pcall(require, file)
  if not ok then
    vim.notify(string.format('Error loading %q => %s', file, res), vim.log.levels.ERROR)
    return
  end
  return res
end--<

req 'rocksdeps'
req 'opts'
req 'foldtext'
req 'plugins'
req 'statusline'
