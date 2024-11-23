local au = require 'utils'.augroup 'VioletTagordoj'

vim.keymap.set('n', '<Leader>a', '<Cmd>Tagordo<CR>')

local tagordujo
local tagordoj_dosierujo

local fh = io.popen 'xdg-user-dir DOCUMENTS'
if fh then
  tagordujo = fh:read() fh:close()
  -- tagordoj_dosierujo = vim.fs.joinpath(vim.env.HOME, 'Dokumentoj', 'Tagordo')
end

if tagordujo then
  tagordujo = vim.fs.joinpath(tagordujo, 'Tagordujo')
else
  tagordujo = vim.fs.joinpath(vim.env.HOME, '.local', 'Dokumentujo', 'Tagordujo')
end

if not (vim.uv.fs_stat(tagordujo) or vim.uv.fs_mkdir(tagordujo, 493)) then return end

vim.api.nvim_create_user_command('Tagordo', function(opts)
  local f = vim.fs.joinpath(tagordujo, os.date '%Y-%m-%d-%a.md')
  vim.cmd.split { args = { f }, mods = opts.smods }
end, {
  nargs = '?',
  desc = "Malfermu la tagordon por hodiaŭ"
})

au {
  'BufNewFile',
  pattern = tagordujo .. '/*.md',
  callback = function()
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { '# ' .. os.date '%a, %d %b %Y', '', '- [ ] ', '' })
    -- vim.api.nvim_feedkeys('GkA', 'L', false)
  end,
}
