local event = require 'pckr.loader.event'

return {

  { 'lervag/vimtex',
    cond = event('FileType', 'tex'),
    config_pre = function()
      vim.g.vimtex_view_general_viewer = 'zathura'
      vim.g.vimtex_echo_verbose_input = 0
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = function() return './.' .. vim.fn.expand '%:t:r' .. '.out' end,
        out_dir = function() return './.' .. vim.fn.expand '%:t:r' .. '.out' end,
        options = {
          '-shell-escape',
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-emulate-aux-dir',
          '-interaction=nonstopmode',
        },
      }
    end,

  },

  { 'KeitaNakamura/tex-conceal.vim',
    cond = event('FileType', 'tex'),
  },

}
