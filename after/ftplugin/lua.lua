vim.keymap.set('i', '<C-r>:', [[histget(':')->substitute('\v^\s*%(lua\=?|h%[elp])\s*', '', '')]], { expr = true })


----> options specific to nvim config
local bufname = vim.api.nvim_buf_get_name(0)
local cfgdir = vim.fn.stdpath 'config' .. '/'
if vim.startswith(bufname, cfgdir) then
  vim.wo.foldmarker = '-->,--<'
  vim.wo.foldmethod = 'marker'
  vim.wo.foldlevel = 0

  vim.api.nvim_buf_set_keymap(0, 'n', 'zf', ':<C-u>set opfunc=luafold#createFold<CR>g@',
    { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, 'x', 'zf', ':<C-u>call luafold#createFold(visualmode())<CR>',
    { noremap = true, silent = true })

  if bufname ~= 'init.lua' and vim.fs.dirname(bufname):find '/lua/plugins$' then
    vim.keymap.set('n', '<LocalLeader>s', function()
      local load = loadfile(bufname)
      if load then
        local env = {}
        for k, v in pairs(_G) do
          env[k] = v
        end
        setfenv(load, env)
        local ok, pkgs = pcall(load)
        if ok then
          local loaded = vim.iter(pkgs)
              :map(function(pkg)
                local p = pkg[1]:gsub('^.*/', ''):gsub('[-.]n?vim$', ''):gsub('^vim%-?', '')
                if pkg.config and package.loaded[p] then
                  local err
                  ok, err = pcall(pkg.config)
                  if ok then
                    return pkg[1]
                  else
                    vim.notify(string.format(
                      'Error loading %q (in %q): %s',
                      pkg[1], vim.fs.basename(bufname), err))
                  end
                end
              end)
              :totable()
          if #loaded == 0 then
            vim.notify(string.format('No packages reloaded from plugins/%s',
              vim.fs.basename(bufname)), vim.log.levels.INFO)
          else
            vim.notify(string.format(
              '%d package%s loaded from plugins/%s: %s',
              #loaded,
              #loaded == 1 and '' or 's',
              vim.fs.basename(bufname),
              table.concat(loaded, ', ')), vim.log.levels.INFO)
          end
        else
          vim.notify(string.format(
              'Could not load plugins/%s: %s',
              vim.fs.basename(bufname), pkgs),
            vim.log.leves.ERROR)
        end
      end
    end)
  end
end --<
