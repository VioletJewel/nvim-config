local d = vim.fn.stdpath 'data' ---@cast d string

local lazypath = vim.fs.joinpath(d, 'lazy', 'lazy.nvim')

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require 'lazy'.setup('plugins', {
  install = {
    missing = true,
    colorscheme = { 'habamax' }
  },
  defaults = { lazy = true },
  ui = {
    border = 'rounded',
    backgroup = 60,
  },
  checker = { enabled = true, notify = false },
  lockfile = vim.fs.joinpath(d, 'lazy-lock.json'),
  change_detection = { notify = false, },
  performance = { rtp = { disabled_plugins = {
    'gzip',
    'matchit',
    'matchparen',
    'netrwPlugin',
    'tarPlugin',
    'tohtml',
    'tutor',
    'zipPlugin',
    'rplugin',
    'osc52',
  } } },
  debug = false,
})
