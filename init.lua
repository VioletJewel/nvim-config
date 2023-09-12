-- Author: Violet
-- Last Change: 07 August 2023

local color = require'utils'.color
local load = function(pkg) pcall(require, pkg) end

color'nokto'
load'opts'
load'packages'
color'nokto'
load'lsp'

