-- Author: Violet
-- Last Change: 19 July 2023

local au = require'utils'.augroup'VioletPandoc'

local pandoc_t = {}

vim.api.nvim_create_user_command('Pandoc', function()
  local i, o, t
  i = vim.fn.expand('%')
  if i:sub(-3) ~= '.md' then
    return
  end
  o = vim.fn.expand('%:r')..'.pdf'
  t = vim.b.pandoc_template or vim.g.pandoc_template or 'eisvogel'

  local pid

  local function pandoc_exit(s)
    if s.code ~= 0 then
      print(":Pandoc failed:", s.stderr)
      return
    end
    pandoc_t[pid] = nil
  end

  for _, v in pairs(pandoc_t) do
    print'Already running :Pandoc'
    if v == o then return end
  end

  pid = vim.system(
    {'pandoc', '--from', 'markdown', '--template', t, '--listings', i, '-o', o},
    nil,
    pandoc_exit
  )
  pandoc_t[pid] = o
end, {nargs=0})

au( 'BufWritePost', {
  desc     = 'auto `!Pandoc %` on :write for *.md',
  pattern  = '*.md',
  callback = function()
    if vim.fn.getline(1) ~= '---' then
      vim.cmd'Pandoc'
    end
  end,
})

