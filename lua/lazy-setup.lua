local d = vim.fn.stdpath 'data' ---@cast d string

local lazypath = vim.fs.joinpath(d, 'lazy', 'lazy.nvim')

if not vim.loop.fs_stat(lazypath) then
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
    colorscheme = { 'dracula' }
  },
  defaults = { lazy = false },
  ui = {
    border = 'rounded',
    backgroup = 60,
  },
  checker = { enabled = true, notify = false },
  lockfile = vim.fs.joinpath(d, 'lazy-lock.json'),
  change_detection = { notify = false, },
  debug = false,
})
