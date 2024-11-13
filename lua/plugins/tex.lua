return {
  {
    'lervag/vimtex',
    ft = 'tex',
    config = function()
      vim.g.vimtex_view_general_viewer = 'zathura'
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
    end
  },

  {
    'KeitaNakamura/tex-conceal.vim',
    ft = 'tex',
  },
}
