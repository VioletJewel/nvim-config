local M = {}

local _defaultTheme = 'habamax'

function M.setup(opts)
  Theme = opts.theme or _defaultTheme
end

local function parseuri(uri) -->
  local name = uri:match '([^/]*)/n?vim$' or uri:match '[^/]*/([^/]*)$'
  if not name then return end
  return name
      :gsub('^n?vim%-', ''):gsub('^colors?%-', '')
      :gsub('%.n?vim$', ''):gsub('%-?colors?$', '')
end --<

local _trim = { trimempty = true }
local _cmp

function M.parse(pkgs) -->
  local cmpi = 0
  local cmp = {}
  local inittheme = type(Theme) == 'table' and Theme or { Theme }
  local initthemename
  if type(inittheme[1] == 'string') then
    initthemename = inittheme[1]
  end
  local didinittheme = false
  local uris = vim.iter(ipairs(pkgs)):map(function(_, pkg)
    local _, uri, name, pats, init
    if type(pkg) == 'table' then -- { 'my/theme', ... }
      uri = pkg[1]
      name = parseuri(uri)
      local g = pkg.g or name .. '_style'  -- { 'my/theme', g = 'theme_style', ... }
      if pkg.pats then                     -- { 'my/theme', pats = ..., ... }
        if type(pkg.pats) == 'string' then -- { 'my/theme', pats = '%:g=red,%-{blue,pink}-dark', ... }
          pats = pkg.pats:gsub('%%', name)
          pats = pats:gsub('([^,]*){([^}]*)}([^,]*)', function(pre, spat, post)
            return pre .. spat:gsub(',', function()
              return post .. ',' .. pre
            end) .. post
          end)
          pats = vim.gsplit(pats, ',', _trim)
          pats = vim.iter(pats):map(function(pat)
            local gpos, _ = pat:find ':g='
            if gpos then -- g:={g_variant}
              pat = { pat:sub(1, gpos - 1), globals = { [g] = pat:sub(gpos + 3) }, _g = g }
            end
            if pat == initthemename then init = pat end
            return pat
          end):totable()
        else
          pats = vim.iter(ipairs(pkg.pats)):map(function(_, pat)
            pat = pat:gsub('%%', name)
            local gpos, _ = pat:find ':g='
            if gpos then
              pat = { pat:sub(1, gpos - 1), globals = { [g] = pat:sub(gpos + 3) }, _g = g }
            end
            if pat == initthemename then init = pat end
            return pat
          end):totable()
        end
      else
        pats = { name }
        if name == initthemename then init = name end
      end
    else
      uri = pkg
      name = parseuri(uri)
      pats = { name }
      if name == initthemename then init = name end
    end
    cmpi = cmpi + 1
    cmp[cmpi] = pats
    -- print('init', init)
    if init then didinittheme = true end
    local ret = {
      uri,
      name = name,
      event = init and 'VimEnter' or nil,
      -- priority = init and 1000 or nil,
      init = init and inittheme.init or nil,
      opts = init and inittheme.opts or nil,
      config = init and function(t, opts)
        -- print('config')
        if t and init.opts then
          require(t.name).setup(opts)
        end
        if init.globals then
          for g, v in ipairs(init.globals) do
            vim.g[g] = v
          end
        end
        vim.cmd.syntax 'reset'
        vim.cmd.ColorScheme(init[1])
        vim.cmd.doautocmd { args = { 'ColorScheme', init } }
      end or nil,
    }
    -- vim.print(ret)
    return ret
  end):totable()
  if not didinittheme then vim.cmd.colorscheme(Theme) end
  _cmp = vim.iter(cmp):flatten():totable()
  return uris
end                         --<

local function getCmpIter() -->
  return vim.iter(ipairs(_cmp)):map(function(_, cmp)
    if type(cmp) == 'table' then
      if cmp._g then
        return cmp[1] .. '--' .. cmp.globals[cmp._g]
      else
        return cmp[1]
      end
    end
    return cmp
  end)
end -->

function M.getCompletions()
  return getCmpIter():totable()
end

-- :colo -> :Colo hack
vim.keymap.set('ca', 'colo',
  "getcmdtype() is ':' && getcmdline() =~# '^colo' && getcmdpos() is 5 ? 'Colo' : 'colo'",
  { expr = true })

vim.api.nvim_create_user_command('ColorScheme', function(opts)
  local theme
  if opts.args == "" then
    theme = type(Theme) == 'table' and Theme or { Theme }
  else
    theme = opts.args
    local g1, g2 = theme:find '.%-%-.'
    if g1 then
      local style = theme:sub(g2)
      theme = theme:sub(1, g1)
      local _, t = vim.iter(ipairs(_cmp)):filter(function(_, t) return type(t) == 'table' end):find(function(_, t) return
        t[1] == theme and t.globals[t._g] == style end)
      vim.g[t and t._g or theme .. '_style'] = style
    end
  end
  vim.cmd.colorscheme(theme)
end, {
  nargs = '?',
  complete = function(arglead, _, _)
    return getCmpIter():filter(function(cmp)
      return vim.startswith(cmp, arglead)
    end):totable()
  end
})

return M
