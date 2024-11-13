return {
  'VioletJewel/vimterm.nvim',
  opts = { abbrevhack = false, },
  cmd = { 'Sterminal', 'STerminal', },
  init = function()
    -- (hack) expand :term to :Sterm.
    vim.keymap.set('ca', 'term',
      "getcmdtype() is ':' && getcmdline() =~# '^term' && getcmdpos() is 5 ? 'Sterm' : 'term'",
      { expr=true })
    -- (hack) expand :vterm to :vert Sterm.
    vim.keymap.set('ca', 'vterm',
      "getcmdtype() is ':' && getcmdline() =~# '^vterm' && getcmdpos() is 6 ? 'vert Sterm' : 'vterm'",
      { expr=true })
  end,
}
