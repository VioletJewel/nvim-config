-- Author: Violet
-- Last Change: 13 January 2023

local try = require'utils'.try

vim.cmd.colorscheme 'nokto-init'  -- load immediately in case fatal error
try(require, 'opts')              -- load lua/opts.lua early next
try(require, 'packages')          -- load lua/packages.lua next
try(vim.cmd.colorscheme, 'nokto') -- load colorscheme

-- now all plugin/*.{vim,lua} then after/plugin/*.{vim,lua} are loaded in no
-- particular order (although they are loaded alphabetically)
