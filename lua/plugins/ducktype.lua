return {

  {
    'kwakzalver/duckytype.nvim',
    config = function()
      require('duckytype').setup{
        number_of_words = 100,
        highlight = {
          good = "Comment",
          bad = "Error",
          remaining = "Todo",
        },
      }
    end,
  },

}
