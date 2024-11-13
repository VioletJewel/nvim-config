-----e/tokyonight.nvim', }
----- /^n?vim-/, /^colors?-/, /\.n?vim$/, /-?colors?$/ are removed from the URIs
----- below.
-----
----- The following patterns (eg, '%s') are the allowed theme names to be used
----- with :colorscheme or :ColorScheme. %s is replaced with the simplified theme
----- name (eg, { 'folke/tokyonight.nvim', '%s', '%s-day' } yields two themes:
----- tokyonight and tokyonight-day.
-----
----- to customize, set `Theme` in init.lua. Egs:
----- Theme = 'tokyonight'
----- Theme = { 'sonokai', init = function() vim.g.sonokai_style = 'espresso' end }
----- Theme = { 'sonokai', globals = { sonokai_style = 'espresso' }
----- Theme = { 'onedark', opts = { style = 'darker' } } -- lua themes only
----- Theme = function() require 'kanagawa'.load 'wave' end
----- Theme = 'habamax' -- builtin themes work too
-----
----- use :ColorScheme with <Tab> to cycle through all of the themes, which are
----- not loaded until needed

--local themes = {
--  -- uri                                patterns
--  { 'folke/tokyonight.nvim',           '%s', '%s-day',    '%s-night', '%s-storm', },
--  { 'catppuccin/nvim',                 '%s', '%s-frappe', '%s-latte', '%s-macchiato', '%s-mocha', },
--  { 'dracula/vim',                     '%s', },
--  { 'lifepillar/gruvbox8',             '%s', '%s_hard',   '%s_soft', },
--  { 'owickstrom/vim-colors-paramount', '%s', },
--  { 'violetjewel/color-nokto',         '%s', },
--  { 'violetjewel/color-vulpo',         '%s', },
--  { 'sainnhe/sonokai',                 '%s', },
--  { 'rebelot/kanagawa.nvim',           '%s', '%s-dragon', '%s-lotus', },
--  { 'navarasu/onedark.nvim',           '%s', },
--  { 'gbprod/nord.nvim',                '%s', },
--  -- { 'b0o/lavi.nvim',                   '%s', },
--}

--local defaulttheme = type(Theme) == 'table' and Theme or { Theme }
--local t_1defaulttheme = type(defaulttheme[1])

--if not (t_1defaulttheme == 'string' or t_1defaulttheme == 'function') then
--  defaulttheme = { 'habamax' }
--  t_1defaulttheme = 'string'
--end

--local ignorethemes = {
--  'blue', 'darkblue', 'delek', 'desert', 'elflord', 'evening', 'industry',
--  'koehler', 'lunaperche', 'morning', 'murphy', 'pablo', 'peachpuff', 'ron',
--  'shine', 'torte', 'vim', 'zaibatsu'
--}


---- :colo -> :Colo hack
--vim.keymap.set('ca', 'colo',
--  "getcmdtype() is ':' && getcmdline() =~# '^colo' && getcmdpos() is 5 ? 'Colo' : 'colo'",
--  { expr = true })

--local vr = os.getenv 'VIMRUNTIME' --- @cast vr string

--local bthemes = vim.tbl_filter(function(t)
--    return not vim.list_contains(ignorethemes, t)
--  end, vim.iter(vim.api.nvim_get_runtime_file('colors/*.{vim,lua}', true))
--  :map(function(c) return vim.startswith(c, vr) and c:sub(#vr + 9, -5) or nil end)
--  :totable())

--if vim.liht_contains(bthemes, defaulttheme[1]) then
--  require 'utils'.augroup 'ViTheme' {
--    'VimEnter',
--    callback = function()
--      if defaulttheme.init then defaulttheme.init() end
--      if t_1defaulttheme == 'string' then
--        vim.cmd.colorscheme(defaulttheme[1])
--        vim.cmd.doautocmd { args = { 'ColorScheme', defaulttheme[1] } }
--      else
--        defaulttheme[1]()
--      end
--    end
--  }
--end

--local _themes = vim.iter(themes)
--    :map(function(theme)
--      local pats = vim.iter(theme)
--      local uri = pats:next()
--      local name = uri:match '([^/]*)/n?vim$' or uri:match '[^/]*/([^/]*)$'
--      if name then
--        name = name:gsub('^n?vim%-', '')
--        name = name:gsub('^colors?%-', '')
--        name = name:gsub('%.n?vim$', '')
--        name = name:gsub('%-?colors?$', '')
--        local ts = pats:map(function(pat)
--          local p = pat:gsub('%%s', name)
--          return p
--        end):totable()
--        vim.list_extend(bthemes, ts)
--        local default = vim.list_contains(ts, defaulttheme[1])
--        return {
--          uri,
--          name = name,
--          event = default and 'VimEnter' or nil,
--          priority = default and 1000 or nil,
--          config = default and function(t, opts)
--            if t and defaulttheme.opts then
--              require(t.name).setup(opts)
--            end
--            if defaulttheme.globals then
--              for g, v in pairs(defaulttheme.globals) do
--                vim.g[g] = v
--              end
--            end
--            vim.cmd.colorscheme(defaulttheme[1])
--            vim.cmd.doautocmd { args = { 'ColorScheme', defaulttheme[1] } }
--          end or nil,
--          init = defaulttheme.init,
--          opts = defaulttheme.opts,
--        }
--      else
--        vim.api.nvim_err_writeln('Invalid theme URI: ' .. uri)
--      end
--    end)
--    :totable()

--vim.api.nvim_create_user_command('ColorScheme', function(opts)
--  vim.cmd.colorscheme(opts.args == "" and defaulttheme[1] or opts.args)
--end, {
--  nargs = '?',
--  complete = function(arglead, _, _)
--    return vim.tbl_filter(function(ct)
--      return vim.startswith(ct, arglead)
--    end, bthemes)
--  end
--})

return require 'utils.theme'.parse {
  -- uri                                patterns
  { 'folke/tokyonight.nvim', pats = '%,%-{day,night,storm}', },
  { 'rebelot/kanagawa.nvim', pats = { '%', '%-dragon', '%-lotus' } },
  { 'catppuccin/nvim',       pats = '%,%-{frappe,latte,macchiato,mocha}' },
  { 'lifepillar/gruvbox8',   pats = '%,%{_hard,_soft}' },
  { 'sainnhe/sonokai',       pats = '%:g={default,atlantis,andromeda,shusia,maia,espresso}', },
  'dracula/vim',
  'owickstrom/vim-colors-paramount',
  'violetjewel/color-nokto',
  'violetjewel/color-vulpo',
  'navarasu/onedark.nvim',
  'gbprod/nord.nvim',
  -- 'b0o/lavi.nvim',
}
