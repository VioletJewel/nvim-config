local cmd = vim.api.nvim_create_user_command

local docsdir
do
  local fh = io.popen 'xdg-user-dir DOCUMENTS'
  if fh then
    docsdir = fh:read()
    fh:close()
  end
end

local au = require 'utils.augroup' 'ViJournal'

cmd('Journal', function(o)
  local time, err = require 'utils.date'.relDateToTime(o.args:lower())
  if err then
    print "That's not a real time!"
  end
  -- vim.print(o.smods)
  vim.cmd[o.bang and 'edit' or require 'utils.win'.shouldSplit() and 'split' or 'edit'] {
    docsdir .. os.date('/journal/%Y-%m-%d.md', time),
    mods = o.bang ~= true and o.smods or nil
  }
end, {
  nargs = '?',
  bang = true,
})

au { 'BufNewFile',
  ---@diagnostic disable-next-line: param-type-mismatch
  pattern = vim.fs.joinpath(vim.fn.fnameescape(docsdir), 'journal', '*.lua'),
  callback = function(evt)
    if vim.b[evt.buf].journalSkeletonGuard then
      return
    end
    vim.b[evt.buf].journalSkeletonGuard = true
    vim.api.nvim_buf_set_lines(evt.buf, 0, 1, true, {
      "TODO: add skeleton script and finish journal skeleton",
    })
  end,
  desc = 'Populate new plugin with a skeleton'
}

