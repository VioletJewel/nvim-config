return {

  {
    'dhruvasagar/vim-table-mode',
    lazy = true,
    ft = 'markdown',
  },

  {
    'preservim/vim-markdown',
    init = function()
      vim.g.vim_markdown_override_foldtext = 0
      vim.g.vim_markdown_no_default_key_mappings = 1
      vim.g.vim_markdown_folding_disabled = 1
    end
  },

}
