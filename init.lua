-- Author: Violet
-- Last Change: 02 April 2023

local load = function(pkg)
  pcall(require, pkg)
end

local colorok = false
local color = function(col)
  -- print(vim.o.rtp)
  if not colorok then
    colorok = pcall(vim.cmd.colorscheme, col)
  end
end

-- load things in specific order

color'nokto'   -- try to load colorscheme (can't load earlier (easily))
load'opts'     -- load lua/opts.lua early next
load'packages' -- load lua/packages.lua next
color'nokto'   -- try to load colorscheme (can't load earlier (easily))
load'lsp'      -- load lua/lsp.lua

-- during init, plugin/*.{vim,lua} then after/plugin/*.{vim,lua} are loaded in
-- no particular order (although they are loaded alphabetically)
