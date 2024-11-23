-- different themes for different times of day
local themes = {
  { '00:00', 'kanagawa-dragon' },
  { '02:00', 'nokto' },
  { '04:00', 'paramount' },
  { '06:00', 'tokyonight-night' },
  { '08:00', 'kanagawa' },
  { '10:00', 'sonokai-atlantis' },
  { '12:00', 'onedark' },
  { '14:00', 'nord' },
  { '16:00', 'catppuccin-frappe' },
  { '18:00', 'dracula' },
  { '20:00', 'gruvbox8_soft' },
  { '21:00', 'gruvbox8' },
  { '22:00', 'gruvbox8_hard' },
  { '23:00', 'vulpo' },
}

-- for _, tt in ipairs(themes) do
--   -- local h, m = tt[1]:match '^(%d%d?)[:. ]?(%d?%d?)$'
--   local h, m = ((vim.lpeg.R '09'^-2/1) * vim.lpeg.S ':. '/0 * (vim.lpeg.R '09'^-2/2)):match(tt[1])
--   print('h', h, 'm', m)
-- end

require 'utils.theme'.setup {
  -- theme = 'kanagawa' -- 'tokyonight', { 'sonokai', globals = { sonokai_style = 'espresso' } }
  theme = os.getenv 'TERM' == 'linux' and 'elflord' or os.getenv 'NVIM_THEME' or 'tokyonight'
}
